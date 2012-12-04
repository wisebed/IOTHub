module DataBackends
  class Rdb < ActiveRecord::Base
    belongs_to :experiment_run
    
    
  end
end
