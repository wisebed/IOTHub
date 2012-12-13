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

  def connected_and_logged_in_tb
    tb = Wisebed::Testbed.new(testbed.shortname)
    tb.login!(login_data)
    tb
  end

  # Executes this testrun on the testbed.
  # Only executeable when this model is valid?
  def run!
    make_reservation unless state
    init_backend! unless @backend

    puts "running exp-run: state is: #{state}"

    if self.state == :sheduled
      # sleep oder so
    elsif self.state == :finished
      # do nothing, should not happen
    elsif self.state == :canrun
      tb = connected_and_logged_in_tb

      exp_id = tb.experiments
      Wisebed::Client.new.experimentconfiguration=self.download_config_url

      wsc = Wisebed::WebsocketClient.new(exp_id,tb.cookie)
      Timeout::timeout((runtime+1)*60) do
        # TODO: use @backend here
        f = @backend.log
        wsc.attach {|msg| print "."; f.write msg}
        while true do sleep 1 end
      end
      wsc.detach
      f.close
      update_attribute(:state, :finished)
    end
  end


  def make_reservation(tb=nil)

    tb = connected_and_logged_in_tb unless tb
    begin
      # TODO: user config.nodes instead of harcoded nodes here!
      reservation = tb.make_reservation(Time.now, Time.now+(60*runtime), "Reservation via IoTHub for #{user.name}", @backend.config.nodes)
      update_attribute(:state, :canrun)
      update_attribute(:reservation, reservation.to_json)
    rescue RuntimeError => e
      # WTF?! not sure why make_reservation does not pass the exception up to here...
      # e.message is an empty string, why?!?
      #if e.message.include? "Another reservation is in conflict with yours"
        # shedule this for later
        puts "rescued exception for reservation conflict, sheduling this run for later"
        update_attribute(:state, :sheduled)
        # do not set start_time, do not set end_time
      #else
        # failreason = "Could not make reservation. API-Response: #{e.message}"
      #end
    end
  end

  def init_backend!
    @backend = DataBackends::LocalFlatFile.new(self) unless @backend
  end

end
