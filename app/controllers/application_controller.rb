class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login

  def require_admin_user
    if current_user.type != "AdminUser"
      # not allowed for non-admin users!
      redirect_back_or_to login_url, :alert => "this account is not allowed for administration", :status => :forbidden
    end
  end

  def not_authenticated
    redirect_to login_url, :alert => "log in to access this page."
  end

end
