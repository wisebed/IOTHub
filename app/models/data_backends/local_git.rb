module DataBackends
  class LocalGit

    require 'grit'
    include Grit # for easy access to Repo

    extend ActiveModel::Naming

    # begin ActiveModel compat methods
    def to_model
      self
    end

    def valid?()      true end
    def new_record?() true end
    def destroyed?()  true end

    def errors
      obj = Object.new
      def obj.[](key)         [] end
      def obj.full_messages() [] end
      obj
    end
    # end ActiveModel compat methods

    attr_accessor :repo

    # Initializes this ExperimentData object with a local git repository.
    #
    # @param [String] the name of this experiment repo (will be made filesystem friendly!)
    # @return [DataBackends::LocalGit] the new object
    def initialize(name)

      # gsub null byte, prevent directory traversal by taking only the file basename and
      # make sure that there are no in any other means bad chars in it.
      name = CGI.escape(File.basename(name.gsub("\000","")))

      # loads the repo from local filesystem
      @repo = Repo.new(GIT_LOCAL_ROOT+'/'+name)
    end

    #def commits(all=false)
    #  commits = []
    #  if all
    #    @repo.commits.each
    #  else
    #    @repo.commits(10)
    #  end
    #end

    # List all branches of this Experiment
    #
    # @return [Grit::Head] the head commits of all branches
    def branches
      @repo.branches
    end

    # Finds the latest version of this Experiment
    #
    # @ return [Grit::Commit] the latest commit
    def current
      @repo.commits.first
    end

    # Finds the config file from the latest commit.
    # Method called _json to open the way for possible other formats
    # in the future. Think of XML or whatever.
    #
    # @return [String] the config file content
    def config_json(from = nil)
      if from
        (@repo.tree(from) / "config.json").data
      else
        (current.tree / "config.json").data
      end
    end

    # Lists the names of all binaries in this experiment that are specified in config.json
    #
    # @return [Array<String>] list of names
    def binary_names
      names = []
      JSON::parse(config_json)['configurations'].each do |config|
        names << config['binaryProgramUrl']
      end
      names
    end

    # Gets a file specifed by name.
    # To get the actual content of the file, call :data on it
    #
    # @param [String] the filename
    # @return [Grit::Blob] the Blob object
    def get_file(name)
      (current.tree / name)
    end

  end
end
