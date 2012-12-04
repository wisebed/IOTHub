class ExperimentRun < ActiveRecord::Base
  belongs_to :experiment
  has_one :testbed

  # The DataBackend object. Set it in :backend!
  @backend = nil

  # opens the repo
  def backend!
    #@backend = DataBackends::LocalGit.new("runs-"+data_path)
    @backend = DataBackends::LocalFlatFile.new(experiment_id+"_"+experiment_version+"_"+start_time+".txt")
  end

  # generates the config of this run
  # If the DataBackend is not yet initialized, it will do so
  #
  # @return [Hash] a Hash of the configuration
  def config
    backend! unless @backend
    h = JSON::parse(@backend.config_json)
    h
  end

  # Executes this testrun on the testbed.
  # Only executeable when this model is valid?
  def run!
    # Here it might be a good choice to use some kind of webserver/worker seperation!
    puts "Running trolololo not yet really implemented!"
  end

end
