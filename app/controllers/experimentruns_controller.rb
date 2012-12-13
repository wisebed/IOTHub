class ExperimentrunsController < ApplicationController
  skip_before_filter :require_login, :only => [:get_static, :show, :index]

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

  # GET    /experiments/:experiment_id/runs/:run_id/static/:filename(.:format)
  # Serves the user static content
  #
  def get_static
    @run = ExperimentRun.find(params[:run_id])
    if params[:extension] == "json"
      render :file => @run.backend.get_static_path(params[:filename]+"."+params[:extension]), :content_type => 'application/json'
    else
      send_file(File.open(@run.backend.get_static_path(params[:filename]+"."+params[:extension])))
    end

  end

end
