class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:show, :index, :new, :create]
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    raise SecurityError unless (params[:id].to_i == current_user.id) or current_user.is_admin?
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        #format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    raise SecurityError unless (params[:id].to_i == current_user.id) or current_user.is_admin?

    @user = User.find(params[:id])

    # updates User to AdminUser
    if current_user.is_admin?
      if params[:is_allowed_to_be_an_admin] and params[:is_allowed_to_be_an_admin] == 'YES'
        @user.type="AdminUser"
      end
    end

    # update the UserTestbedCrendetials here:
    existing_credentials = @user.user_testbed_credentials
    params[:credentials].each_value do |h|
      updated = false
      for_testbed = Testbed.find_by_shortname(h[:shortname])
      existing_credentials.each { |co|
        # updating existing credentials
        if co.testbed == for_testbed
          if h[:password].gsub("*","").length > 0
            co.username = h[:username]
            co.password = h[:password]
            co.save
          end
          updated = true
        end
      }
      if (not updated) and h[:password].gsub("*","").length > 0
        # the supplied credentials where not updated => create new object
        new_utc = UserTestbedCredential.new(:testbed_id => for_testbed.id,
                                            :username => h[:username],
                                            :password => h[:password])
        new_utc.user = @user
        new_utc.save
      end
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user.as_user, notice: 'User was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    raise SecurityError unless (params[:id].to_i == current_user.id) or current_user.is_admin?

    @user = User.find(params[:id])
    if @user.experiments.empty? and @user.experiment_runs.empty?
      logout if @user == current_user
      @user.destroy
    else
      raise "Trying to delete user with experiments. This is not yet possible, sorry!"
    end


    respond_to do |format|
      format.html { redirect_to users_url }
      #format.json { head :no_content }
    end
  end
end
