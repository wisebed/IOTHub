class ExperimentRun < ActiveRecord::Base
  belongs_to :experiment
  has_one :testbed
end
