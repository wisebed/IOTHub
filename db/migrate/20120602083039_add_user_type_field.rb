class AddUserTypeField < ActiveRecord::Migration
  def change
    add_column :users, :type, :string, :default => "", :null => false
  end
end
