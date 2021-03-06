class ExperimentsController < ApplicationController
  skip_before_filter :require_login, :only => [:show, :list_public]

  def list_public(howmany = 20)
    Experiment.where(:visibility => 'public')[0..howmany-1]
  end

  # GET /experiements/1
  # GET /experiements/1.json
  def show
    @experiment = Experiment.find(params[:id])

    unless current_user_is_admin? or @experiment.visibility == "public" or @experiment.user == current_user
      #@experiemnt_alternatives = find_alternatives_for(@experiment)
      render '_notpublic'
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @experiment }
    end
  end

  # GET /experiements
  # GET /experiements.json
  def index
    @experiments = list_public
    begin
      @experiments_by_user = current_user.experiments
    rescue Exception
      # seems we dont have a session
    end
    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @experiments }
    end
  end

  # GET /experiements/new
  # GET /experiements/new.json
  def new
    @experiment = Experiment.new

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @experiment }
    end
  end

  # GET /experiements/1/edit
  def edit
    @experiment = Experiment.find(params[:id])
    raise SecurityError unless (@experiment.user == current_user) or current_user_is_admin?
  end

  # POST /experiements
  # POST /experiements.json
  def create
    @experiment = Experiment.new(params[:experiment])
    @experiment.user = current_user
    @experiment.visibility = params[:experiment][:visibility] == 1 ? :public : :private

    respond_to do |format|
      if @experiment.save
        format.html { redirect_to @experiment, notice: 'Experiments was successfully created.' }
        #format.json { render json: @experiment, status: :created, location: @user }
      else
        format.html { render action: "new" }
        #format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /experiements/1
  # PUT /experiements/1.json
  def update
    @experiment = Experiment.find(params[:id])
    raise SecurityError unless (@experiment.user == current_user) or current_user_is_admin?

    # updates the visibility from checkbox to "public" or "private"
    params[:experiment][:visibility]= params[:experiment][:visibility] == "1" ? "public" : "private"

    respond_to do |format|
      if @experiment.update_attributes(params[:experiment])
        format.html { redirect_to @experiment, notice: 'Experiment was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        #format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experiements/1
  # DELETE /experiements/1.json
  def destroy
    @experiment = Experiment.find(params[:id])
    raise SecurityError unless (@experiment.user == current_user) or current_user_is_admin?
    @experiment.destroy

    respond_to do |format|
      format.html { redirect_to experiments_url }
      #format.json { head :no_content }
    end
  end

end