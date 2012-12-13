class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :name, :email, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :experiments
  has_many :user_testbed_credentials
  has_many :experiment_runs
  
  def isAdmin?
    return false
  end


end
