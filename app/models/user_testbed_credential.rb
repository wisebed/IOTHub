class UserTestbedCredential < ActiveRecord::Base
  belongs_to :user
  belongs_to :testbed
end