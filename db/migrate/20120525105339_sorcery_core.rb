class SorceryCore < ActiveRecord::Migration
  def change
      change_column :users, :email, :string, :null => false # if you use this field as a username, you might want to make it :null => false.
      add_column :users, :crypted_password, :srtring, :default => nil
      add_column :users,  :salt, :string, :default => nil
  end
end