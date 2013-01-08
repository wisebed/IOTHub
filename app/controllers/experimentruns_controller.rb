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

  # GET experiments/:experiment_id/runs/new
  def new
    @run = ExperimentRun.new
    @exp = Experiment.find(params[:experiment_id])
    respond_to do |format|
      format.html {  render :partial => "experimentruns/new", :layout => nil }
    end
  end

  # POST experiments/:experiment_id/runs
  # POST experiments/:experiment_id/runs.json
  def create
    @run = ExperimentRun.new()
    @run.experiment = Experiment.find(params[:experiment_run][:experiment_id])
    @run.testbed = Testbed.find_by_shortname(params[:experiment_run][:testbed])
    @run.user_id = current_user.id
    @run.runtime = params[:experiment_run][:runtime]
    @run.download_config_url = params[:experiment_run][:download_config_url]

    respond_to do |format|
      if @run.save
        @run.delay.run!
        format.html { redirect_to experiment_path(params[:experiment_run][:experiment_id]), notice: 'Run was successfully created.' }
        format.json { render json: @run, status: :created, location: experiment_path(params[:experiment_run][:experiment_id]) }
      else
        format.html { redirect_to experiment_path(params[:experiment_run][:experiment_id]), notice: 'Error while creating Run: ' + @run.errors }
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
    elsif params[:extension] == "txt"
      send_file(File.open(@run.backend.get_static_path(params[:filename]+"."+params[:extension])), :content_type => 'text/plain')
    else
      send_file(File.open(@run.backend.get_static_path(params[:filename]+"."+params[:extension])))
    end

  end

  # DELETE /experiments/:experiment_id/runs/:run_id
  def destroy
    @run = ExperimentRun.find(params[:id])
    raise SecurityError unless (@run.user == current_user) or current_user.is_admin?
    @run.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

end
