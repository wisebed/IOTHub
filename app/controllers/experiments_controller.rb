class ExperimentsController < ApplicationController
  skip_before_filter :require_login, :only => [:show, :list_public]
  
  def list_public(howmany = 20)
    Experiment.where(:visibility => 'public')
  end

  # GET /experiements/1
  # GET /experiements/1.json
  def show
    @experiment = Experiment.find(params[:id])

    unless @experiment.visibility == "public" or session.user.id == @experiment.user_id
      @experiemnt_alternatives = find_alternatives_for(@experiment)
      render 'experiments/notpublic'
      return
    end


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @experiment }
    end
  end  
  
end