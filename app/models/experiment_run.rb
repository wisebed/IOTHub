class ExperimentRun < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :user
  belongs_to :testbed

  after_save :init_backend!

  require 'wisebedclientruby'

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
                "password"=> tbcreds.password
            }
        ]
    }
    logindata
  end

  def tb
    @tb || connected_and_logged_in_tb
  end

  def connected_and_logged_in_tb
    @tb = Wisebed::Testbed.new(testbed.shortname)
    @tb.login!(login_data)
    @tb
  end

  # Executes this testrun on the testbed.
  # Only executeable when this model is valid?
  def run!
    init_backend! unless @backend
    make_reservation unless state == :canrun or state == :finished

    puts "running exp-run: state is: #{state}"

    if self.state == :canrun and self.start_time < Time.now
      Thread.new do
        puts "now running experimentRun #{self.id} on #{self.testbed.id}"
        experiment_id = tb.experiments(JSON.parse(self.reservation))
        tb.flash(experiment_id, self.download_config_url)
        # TODO: wait for flashing to finish

        wsc = Wisebed::WebsocketClient.new(testbed.shortname, tb.cookie)
        Timeout::timeout((runtime+1)*60) do
          f = @backend.log
          wsc.attach {|msg| print "."; f.write msg}
          while true do sleep 1 end
        end
        wsc.detach
        f.close
        update_attribute(:state, :finished)
      end
    else
      if self.reservation and self.start_time
        # if we have a reservation, run this again at the starting time
        self.delay(:run_at => self.start_time.in_time_zone).run!
      else
        # however if not reserved yet, just try again in a minute
        self.delay(:run_at => 1.minutes.from_now).run!
      end
    end
  end



  def make_reservation()
    begin
      reservation = tb.make_reservation(Time.now, Time.now+(runtime.minutes), "Reservation via IoTHub for #{user.name}", @backend.config.nodes)
      update_attribute(:state, :canrun)
      update_attribute(:reservation, reservation.to_json)
      update_attribute(:start_time, Time.now)
    rescue RuntimeError => e
      # could not make reservation right now, trying to schedule it
      reservations = tb.public_reservations(Time.now, Time.now+1.day)
      reservations.each do |r|
        begin
          try_to_start_at = Time.at(r["to"]/1000+1.minute)
          puts "Trying to reservate at: #{try_to_start_at}"
          reservation = tb.make_reservation(try_to_start_at, try_to_start_at+(runtime.minutes), "Reservation via IoTHub for #{user.name}", @backend.config.nodes)
          update_attribute(:state, :canrun)
          update_attribute(:reservation, reservation.to_json)
          update_attribute(:start_time, try_to_start_at)
          break
        rescue RuntimeError => e
          # do nothing, try next
        end
      end
    end
    # if still not in :canrun state, set it to :scheduled to try later
    update_attribute(:state, :scheduled) unless self.state
  end

  def init_backend!
    @backend = DataBackends::LocalFlatFile.new(self) unless @backend
  end

end
