class ExperimentRun < ActiveRecord::Base
  belongs_to :experiment
  has_one :testbed

  # The DataBackend object. Set it in :repo!
  @repo = nil

  # opens the repo
  def repo!
    @repo = DataBackends::LocalGit.new("runs-"+data_path)
  end

  # generates the config of this run
  # If the DataBackend is not yet initialized, it will do so
  #
  # @return [Hash] a Hash of the configuration
  def config
    repo! unless @repo
    h = JSON::parse(@repo.config_json)

  end

end
