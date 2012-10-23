module DataBackends
  # makes sure the path is set
  ENV['GIT_LOCAL_ROOT'] ||= "/tmp/git_local_root/"
  GIT_LOCAL_ROOT = ENV['GIT_LOCAL_ROOT']
end