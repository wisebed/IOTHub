class ExperimentrunController < ApplicationController

  def index
    # TODO: implement!
    # list all recent and currently running runs (if permission allow so)
  end

  # GET experimentrun/:hash
  def show
    # TODO: implement!
  end

  # GET experimentrun/:hash/config
  def config
    @er = ExperimentRun.find_by_commit(params[:hash])
    @er.repo!
    config = @er.config
  end

end
