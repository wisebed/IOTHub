class SessionsController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :create_from_github]

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Email or password was invalid"
      render :new
    end
  end

  def create_from_github
    user = User.find_by_github_uid(request.env["omniauth.auth"]["uid"]) || User.create_from_github(request.env["omniauth.auth"])
    auto_login(user)
    redirect_back_or_to root_url, :notice => "Logged in via github.com!"
  end

  def failure_from_github
    flash[:error] = "Error logging in with GitHub. #{params[:message]}"
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end
  
end
