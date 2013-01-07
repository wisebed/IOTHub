class UserTestbedCredential < ActiveRecord::Base
  belongs_to :user
  belongs_to :testbed

  attr_accessible :username, :password, :testbed_id

  def shortname
    self.testbed.shortname
  end
end