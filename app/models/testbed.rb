class Testbed < ActiveRecord::Base

  has_many :experiment_runs
  has_many :user_testbed_credentials

  attr_accessible :wiseml_url

end
