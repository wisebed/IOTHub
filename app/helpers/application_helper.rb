module ApplicationHelper


require 'digest/md5'

def gravatar_url(email,gravatar_options={})
  grav_url = 'http://www.gravatar.com/avatar/'
  grav_url << Digest::MD5.hexdigest(email)+"?"
  grav_url << "size=#{gravatar_options[:size]}" if gravatar_options[:size]
  grav_url << "&default=#{gravatar_options[:default]}" if gravatar_options[:default]
  grav_url
end




end
