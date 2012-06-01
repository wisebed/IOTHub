class Testbed < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :experiment_runs
end
