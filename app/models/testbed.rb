class Testbed < ActiveRecord::Base
  attr_accessible :wiseml_url
  has_many :experiment_runs
  has_many :user_testbed_credentials

end
