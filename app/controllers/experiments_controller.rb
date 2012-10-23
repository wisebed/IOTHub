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
  
  def index
    @experiments = list_public
    begin      
      @experiments_by_user = User.find(session["user_id"]).experiments
    rescue Exception
      # seems we dont have a session
    end
  end
  
end