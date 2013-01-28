class Experiment < ActiveRecord::Base
  has_many :experiment_runs, :dependent => :delete_all
  belongs_to :user

  attr_accessible :name, :visibility, :default_download_config_url, :description

  validates_presence_of :name, :visibility, :default_download_config_url, :user
end
