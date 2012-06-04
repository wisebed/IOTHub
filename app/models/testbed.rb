class Testbed < ActiveRecord::Base
  attr_accessible :wiseml_url
  require 'WiseML'
  has_many :experiment_runs
  has_many :user_testbed_credentials

  def setup
    if @setup.nil?
      require 'open-uri'
      # TODO: smart caching
      @setup = WiseML::WiseML.from_xml(open(self.wiseml_url,"Accept" => "application/xml")).setup
    end
    @setup
  end


end
