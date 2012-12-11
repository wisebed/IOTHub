class ExperimentrunsController < ApplicationController
  
  # GET experiments/:experiment_id/runs
  def index
    # TODO: check permissions
    @runs = Experiment.find(params[:experiment_id]).experiment_runs   
  end

  # GET experiments/:experiment_id/runs/:id
  def show
    @run = ExperimentRun.find(params[:id])
  end
  
  # POST experiments/:experiment_id/runs
  # POST experiments/:experiment_id/runs.json
  def create
    @run = ExperimentRun.new()
    @run.experiment_id = params[:experiment_id]
    # TODO: ask user for testbed
    @run.testbed_id = Testbed.find_by_shortname("uzl").id

    respond_to do |format|
      if @run.save
        Thread.new(@run) do |run|
          puts "this is reality!"
          tbcreds = UserTestbedCredential.where(:user_id => current_user.id, :testbed_id => @run.testbed_id).first
          require 'wisebedclientruby'
          logindata = {
              "authenticationData" => [
                  {
                      "urnPrefix" => tbcreds.testbed.urn_prefix_list,
                      "username" => tbcreds.username,
                      "password"=> tbcreds.password
                  }
              ]
          }
          tb = Wisebed::Testbed.new(tbcreds.testbed.shortname)
          tb.login!(logindata)
          tb.make_reservation(Time.now, Time.now+(60*2), "Reservation via IoTHub for #{current_user.name}", ["urn:wisebed:uzl1:0x2144","urn:wisebed:uzl1:0x2246"])
          exp_id = tb.experiments
          Wisebed::Client.new.experimentconfiguration="https://raw.github.com/itm/wisebed-experiments/master/packet-tracking/config.json"
          wsc = Wisebed::WebsocketClient.new(exp_id,tb.cookie)
          Timeout::timeout(2*60+10) do
            f = File.open("/tmp/wsc_log_#{current_user}_#{Time.now}","w")
            wsc.attach {|msg| print "."; f.write msg}
            #while true do end
          end
        end

        format.html { redirect_to experiment_path(params[:experiment_id]), notice: 'Run was successfully created.' }
        format.json { render json: @run, status: :created, location: experiment_path(params[:experiment_id]) }
      else
        format.html { redirect_to experiment_path(params[:experiment_id]), notice: 'Error while creating Run: ' + @run.errors }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

end
