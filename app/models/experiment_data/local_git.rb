module ExperimentData
  class LocalGit

    require 'grit'
    include Grit

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

    def initialize(name)
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

    def branches
      @repo.branches
    end

    def current
      @repo.commits.first
    end

  end
end
