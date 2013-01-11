module DataBackends
  class LocalFlatFile

    if ENV["storage_base_dir"]
      FILE_BASE_PATH = ENV["storage_base_dir"]
    else
      FILE_BASE_PATH = "/tmp/"
    end


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

    attr_reader :parsed_config, :checksum

    # Initializes this ExperimentData object with a local directory.
    #
    # @param [String] the name of this experiment file (will be made filesystem friendly!)
    # @return [DataBackends::LocalFlatFile] the new object
    def initialize(exp_run_obj)
      @exp_run_obj = exp_run_obj
      puts "[#{Time.now} | #{@exp_run_obj.id.to_s}] init backend (#{self.object_id.to_s})"
      @path = FILE_BASE_PATH+"/"+@exp_run_obj.id.to_s+"_"+@exp_run_obj.testbed_id.to_s+"_"+@exp_run_obj.created_at.to_i.to_s
      unless File.directory?(@path)
        puts "[#{Time.now}] no such directory: #{@path} Creating it."
        system("mkdir -p #{@path}") # TODO: think about security!
      end

      init_config
    end

    # @return [String] the absolut path to given file
    def get_static_path(filename)
      File.join(@path,sanitize(filename))
    end

    # Generates a config object with links to config and bins and list of nodes
    #
    # @return [Hash] the configuration hash + a method to get all nodes
    def config
      def @parsed_config.nodes
        return @nodes unless @nodes.nil?

        require 'open-uri'
        node_links = self["configurations"].inject(Array.new) {|a,c| a << c["nodeUrnsJsonFileUrl"] }
        @nodes = []
        node_links.each do |link|
          @nodes = @nodes.concat(JSON.parse(open(link).read)["nodeUrns"])
        end
        @nodes
      end
      @parsed_config
    end


    # Loads config file and, if not present locally, downloads it and
    # also downloads all needed binaries.
    #
    # @return void
    def init_config

      # if the config file is already locally stored, simply parse that and return
      if File.exists?(File.join(@path,"flash_config.json"))
        @parsed_config = JSON.parse(File.open(File.join(@path,"config.json"),"r").read)
        return
      end

      puts "[#{Time.now}] backend: no local files found, downloading..."

      # otherwise: download the config and all referred binaries
      require 'open-uri'
      # TODO: think about security. Should be safe as long as this is not stored in web-root or something...
      File.open(File.join(@path,"config.json"), 'wb') do |f|
        f.write(open(@exp_run_obj.download_config_url).read)
      end
      @parsed_config = JSON.parse(File.open(File.join(@path,"config.json"),"r").read)

      @parsed_config["configurations"].each do |c|
        filename = sanitize(c["binaryProgramUrl"].split("/").last)

        # If the url looks like a http link, use the full url, otherwise concat
        # the filename on the base path of the download link.
        download = (c["binaryProgramUrl"][0..6] =~ /^http..\//) ? c["binaryProgramUrl"] : @exp_run_obj.download_config_url.split("/")[0..-2].join("/")+"/"+c["binaryProgramUrl"]

        File.open(File.join(@path, filename), 'wb') do |f|
          f.write(open(download).read) # download!
        end
      end

      File.open(File.join(@path, "flash_config.json"), 'w') do |f|
        f.write(Wisebed::Client.new.experimentconfiguration(@exp_run_obj.download_config_url).to_json) # download!
      end

      # if we just donwloaded things, lets calculate the checksum
      @exp_run_obj.update_attribute(:config_checksum,init_checksum)
    end

    # Calculates a checksum over all relevant local files
    #
    # @return [String] a single SHA1 Hex-String
    def init_checksum
      if  @exp_run_obj.config_checksum
        @checksum = @exp_run_obj.config_checksum
      else
        require "digest/sha1"
        long_checksum_string = Dir.glob(@path+"/*.{json,txt,bin}").sort.inject("") do |c,f|
          # Calculate checksum for every file and concat them
          c += Digest::SHA1.hexdigest(File.open(f,"r").read)
        end
        # "compress" the concated checksums by checksumming
        @checksum = Digest::SHA1.hexdigest(long_checksum_string)
      end
      @checksum
    end

    # gsub null byte, prevent directory traversal by taking only the file basename and
    # make sure that there are no in any other means bad chars in it.
    #
    # @return [String] the clean(er) string
    def sanitize(name)
      CGI.escape(File.basename(name.gsub("\000","")))
    end

    # The log file to write the log to. Should be closed after usage.
    #
    # @return [File] an open File
    def log
      open_log unless @log
      @log
    end

    # Open the log file and name it @log
    #
    # @return void
    def open_log
      @log = File.open(@path+"/log.json","w")
    end

    # A list of files that are saved for this experimentrun.
    #
    # @return [Hash] name of file => filesize
    def files
      h = Hash.new
      Dir.glob(@path+"/*.{json,txt,bin}") do |f|
        h[File.basename(f)] = File.size(f)
      end
      h
    end

    def flash_config
      File.read(@path+"/flash_config.json")
    end

  end
end
