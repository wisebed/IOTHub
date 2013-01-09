class Experiment < ActiveRecord::Base
  attr_accessible :name, :visibility, :default_download_config_url, :description
  has_many :experiment_runs, :dependent => :delete_all
  belongs_to :user

end
