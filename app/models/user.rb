class User < ActiveRecord::Base
  attr_accessible :email, :name, :pw
end
