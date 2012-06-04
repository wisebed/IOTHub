class AddUserTestbedCredentials < ActiveRecord::Migration
  def up
    create_table :user_testbed_credentials do |t|
      t.integer :user_id
      t.integer :testbed_id
      t.string :username
      t.string :password
      t.timestamps
    end
    add_index :user_testbed_credentials, :user_id
    add_index :user_testbed_credentials, :testbed_id
    add_index :testbeds, :shortname
  end

  def down
    drop_table :user_testbed_credentials
    remove_index :testbeds, :shortname
  end
end
