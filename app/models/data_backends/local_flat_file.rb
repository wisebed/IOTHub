module DataBackends
  class LocalFlatFile

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

    attr_accessor :raw

    # Initializes this ExperimentData object with a local file.
    #
    # @param [String] the name of this experiment file (will be made filesystem friendly!)
    # @return [DataBackends::LocalFlatFile] the new object
    def initialize(name)

      # gsub null byte, prevent directory traversal by taking only the file basename and
      # make sure that there are no in any other means bad chars in it.
      name = CGI.escape(File.basename(name.gsub("\000","")))

      # loads the raw file from local filesystem
      @raw = File.open(name,"rw")
    end
   
  end
end
