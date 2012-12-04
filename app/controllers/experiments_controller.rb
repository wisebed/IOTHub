class ExperimentsController < ApplicationController
  skip_before_filter :require_login, :only => [:show, :list_public]
  
  def list_public(howmany = 20)
    Experiment.where(:visibility => 'public')[0..howmany-1]
  end

  # GET /experiements/1
  # GET /experiements/1.json
  def show
    @experiment = Experiment.find(params[:id])
                                                                                      
    unless User.find(session["user_id"]).isAdmin? or @experiment.visibility == "public" or session["user_id"] == @experiment.user_id
      #@experiemnt_alternatives = find_alternatives_for(@experiment)
      render '_notpublic'
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @experiment }
    end
  end

  # GET /experiements
  # GET /experiements.json
  def index
    @experiments = list_public
    begin      
      @experiments_by_user = User.find(session["user_id"]).experiments
    rescue Exception
      # seems we dont have a session
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @experiments }
    end
  end
 
  # GET /experiements/new
  # GET /experiements/new.json
  def new
    @experiment = Experiment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @experiement }
    end
  end

  # GET /experiements/1/edit
  def edit
    @experiment = Experiment.find(params[:id])
  end

  # POST /experiements
  # POST /experiements.json
  def create
    @experiment = Experiment.new(params[:experiement])

    respond_to do |format|
      if @experiement.save
        format.html { redirect_to @experiement, notice: 'Experiments was successfully created.' }
        format.json { render json: @experiement, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @experiement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /experiements/1
  # PUT /experiements/1.json
  def update
    @experiement = Experiment.find(params[:id])

    respond_to do |format|
      if @experiement.update_attributes(params[:experiement])
        format.html { redirect_to @experiement, notice: 'Experiment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @experiement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experiements/1
  # DELETE /experiements/1.json
  def destroy
    @experiement = Experiment.find(params[:id])
    @experiement.destroy

    respond_to do |format|
      format.html { redirect_to experiments_url }
      format.json { head :no_content }
    end
  end
  
end