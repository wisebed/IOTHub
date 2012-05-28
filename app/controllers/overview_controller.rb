class OverviewController < ApplicationController
  # all mehtods here are public. For user specific home pages, see users_controller
  skip_before_filter :require_login 
  
  def index
    # we need: Experiments, Users, Testbeds and more...
    ec = ExperimentsController.new
    uc = UsersController.new
    @experiments = ec.list_public(10)
  end
  
end
