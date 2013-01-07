class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :name, :email, :password, :password_confirmation

  validates_presence_of :name

  has_many :experiments
  has_many :user_testbed_credentials
  has_many :experiment_runs
  
  def is_admin?
    false
  end

  def self.create_from_github(env_hash)
    #raise env_hash.to_yaml
    nu = User.new
    nu.name = env_hash["info"]["name"]
    nu.github_uid = env_hash["uid"]
    nu.email = env_hash["info"]["nickname"]+" @ github"
    nu.avatar_url = env_hash["extra"]["raw_info"]["avatar_url"]
    if nu.save
      nu
    else
      # in the unlikely case that on githubs end something changes dramatically, this might happen.
      raise "Could not create user with this info but this should never even get raised here"
    end
  end

end
