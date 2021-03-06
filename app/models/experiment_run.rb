class ExperimentRun < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :user
  belongs_to :testbed

  validates_presence_of :user, :testbed, :experiment, :download_config_url
  validates_numericality_of :runtime, :greater_than => 0

  scope :public, joins('left outer join experiments on experiments.id=experiment_runs.experiment_id').where('experiments.visibility = \'public\' ')

  after_save :init_backend!

  require 'wisebedclientruby'

  attr_accessible :state, :start_time, :finish_time, :reservation, :failreason, :runtime, :tb_exp_id, :config_checksum

  # The DataBackend object. Set it in :backend!
  @backend = nil

  # build the hash with the users credentials for this runs testbed
  def login_data
    tbcreds = UserTestbedCredential.where(:user_id => user.id, :testbed_id => testbed.id).first
    logindata = {
        "authenticationData" => [
            {
                "urnPrefix" => tbcreds.testbed.urn_prefix_list,
                "username" => tbcreds.username,
                "password" => tbcreds.password
            }
        ]
    }
    logindata
  end

  def tb
    @tb || connected_and_logged_in_tb
  end

  def connected_and_logged_in_tb
    begin
      @tb = Wisebed::Testbed.new(testbed.shortname)
      @tb.login!(login_data)
      @tb
    rescue SecurityError => e
      update_attribute(:state, :failed)
      update_attribute(:failreason, e.message)
      exit(0) # so delayed_job does not try to run it again
    end
  end

  # Executes this testrun on the testbed.
  # Only executeable when this model is valid?
  def run!
    begin # for rescue at the bottom
      init_backend! unless @backend
      make_reservation unless self.reservation

      #puts "[#{Time.now} | #{self.id}] state: #{self.state.to_s}, start_time: #{self.start_time ? self.start_time : "nil"}, finish_time: #{self.finish_time ? self.finish_time : "nil"} "
      #puts "is this reality? #{(self.state.to_sym == :canrun).to_s} #{(self.start_time <= Time.now).to_s} #{(self.finish_time > Time.now).to_s}"
      if (self.state.to_sym == :canrun) and (self.start_time <= Time.now) and (self.finish_time > Time.now)
        Thread.new do

          puts "[#{Time.now} | #{self.id}] running experimentRun #{self.id} on #{self.testbed.shortname} now!"
          @backend.event_log.log "run started on #{self.testbed.shortname}"
          update_attribute(:state, :running)
          experiment_id = tb.experiments(JSON.parse(self.reservation))
          @backend.event_log.log "requesting experiment_id, it is: #{experiment_id}"
          update_attribute(:tb_exp_id, experiment_id)
          tb.flash(experiment_id, JSON.parse(@backend.flash_config))
          @backend.event_log.log "flashing nodes"
          # TODO: wait for flashing to finish

          wsc = Wisebed::WebsocketClient.new(experiment_id)
          puts "[#{Time.now} | #{self.id}] attaching in a timeout loop of #{(runtime+1)*60} seconds"
          @backend.event_log.log "attaching to testbed websocket (for #{(runtime+1)*60} seconds)"
          begin
            Timeout::timeout((runtime+1)*60) do
              f = @backend.log
              f.write "["
              wsc.attach { |msg| f.write msg+"," }
              while true do
                sleep((runtime+1)*60)
              end
              # sleeping in this thread to prevent active idle with 100% cpu
            end
          rescue Timeout::Error => te
            # do nothing here
          ensure
            puts "[#{Time.now} | #{self.id}] timeouted. Detaching from websocket, closing file, setting state: Run finished."
            @backend.event_log.log "detaching from testbed websocket, closing log files"
            update_attribute(:state, :finished)
            @backend.log.pos = @backend.log.pos-1 # rewind to the position of the last ,
            @backend.log.write "]\n"
            @backend.log.close
            wsc.detach
            @backend.event_log.log "run finished successfully"
          end


        end
      else
        if self.reservation and self.start_time
          # if we have a reservation, run this again at the starting time
          puts "[#{Time.now} | #{self.id}] has a reservation and a start_time. Creating new job for the start_time (#{self.start_time})"
          if start_time > Time.now
            self.delay(:run_at => self.start_time).run!
          else
            puts "[#{Time.now} | #{self.id}] but start_time is in the past, abandoning this job!"
            raise "could not start the experiment at its reservation time!"
          end

        else
          # however if not reserved yet, just try again in a minute
          puts "[#{Time.now} | #{self.id}] has no reservation. Creating new job for retry in 1 minute!"
          self.delay(:run_at => 1.minutes.from_now).run!
        end
      end

    # huge rescue around the whole processing
    rescue RuntimeError => e
      update_attribute(:state, :failed)
      update_attribute(:failreason, e.message)
    end
  end


  def make_reservation()
    begin
      puts "[#{Time.now} | #{self.id}] Trying to make a reservation right now"
      @backend.event_log.log "trying to make a reservation right now"
      reservation = tb.make_reservation(Time.now, Time.now+(runtime.minutes), "Reservation via IoTHub for #{user.name}", @backend.config.nodes)
      update_attributes(:state => :canrun,
                        :reservation => reservation.to_json,
                        :start_time => Time.now,
                        :finish_time => Time.now+(runtime.minutes)
      )
    rescue RuntimeError => e
      # could not make reservation right now, trying to schedule it
      reservations = tb.public_reservations(Time.now, Time.now+1.day)
      reservations.sort_by! { |res| res["to"]/1000 }
      reservations.each do |r|
        begin
          # rest-ws returns JS compatible int with milliseconds and UTC tz.
          try_to_start_at = Time.at(r["to"]/1000+1.minute)
          puts "[#{Time.now} | #{self.id}] Trying to make a reservation at: #{try_to_start_at}"
          @backend.event_log.log "trying to make a reservation at: #{try_to_start_at}"
          reservation = tb.make_reservation(try_to_start_at, try_to_start_at+(runtime.minutes), "Reservation via IoTHub for #{user.name}", @backend.config.nodes)
          update_attributes(:state => :canrun,
                            :reservation => reservation.to_json,
                            :start_time => try_to_start_at,
                            :finish_time => try_to_start_at+(runtime.minutes)
          )
          puts "[#{Time.now} | #{self.id}] successfully made a reservation at #{try_to_start_at}"
          @backend.event_log.log "successfully made a reservation at #{try_to_start_at}"
          break
        rescue RuntimeError => e
          # do nothing, try next
        end
      end
    end
    # if still not in :canrun state, set it to :scheduled to try later
    puts "[#{Time.now} | #{self.id}] make_reservation: could not make reservation, scheduling it for later" unless self.reservation
    @backend.event_log.log "WARNING! could not make a reservation on #{testbed.shortname}, trying again later..." unless self.reservation
    update_attribute(:state, :scheduled) unless self.reservation
  end

  def backend
    init_backend! unless @backend
    @backend
  end

  def init_backend!
    @backend = DataBackends::LocalFlatFile.new(self) unless @backend
  end

end
