class TestbedController < ApplicationController
  skip_before_filter :require_login, :only => [:show, :index]


  # GET /testbeds/:shortname/authenticate.json
  def authenticate
    secret_auth_keys = current_user.authenticate_with_testbed(Testbed.find_by_shortname(params[:shortname]))
    respond_to do |format|
      if secret_auth_keys
        format.json {
          cookies["wisebed-secret-authentication-key-"+params[:shortname]] = {
              :value => Base64.encode64(secret_auth_keys.to_json),
              :domain => "http://wisebed.itm.uni-luebeck.de"
          }
          render json: secret_auth_keys, :status => :ok }
      else
        format.json { render json: "no", :status => :forbidden }
      end
    end

  end

end