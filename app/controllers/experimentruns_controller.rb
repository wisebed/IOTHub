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
    @run.user_id = current_user.id
    @run.runtime = 2 # two minutes
    @run.download_config_url="https://raw.github.com/itm/wisebed-experiments/master/packet-tracking/config.json"

    respond_to do |format|
      if @run.save
        @run.run!
        format.html { redirect_to experiment_path(params[:experiment_id]), notice: 'Run was successfully created.' }
        format.json { render json: @run, status: :created, location: experiment_path(params[:experiment_id]) }
      else
        format.html { redirect_to experiment_path(params[:experiment_id]), notice: 'Error while creating Run: ' + @run.errors }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

end
