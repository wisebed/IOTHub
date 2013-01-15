class TestbedController < ApplicationController
  skip_before_filter :require_login, :only => [:show, :index]

end