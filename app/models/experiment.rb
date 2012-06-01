class Experiment < ActiveRecord::Base
  attr_accessible :name, :user_id, :visibility
  has_many :experiment_runs
  belongs_to :user

  
  
end
