class TestbedInfo < ActiveRecord::Migration
  def change
    add_column :testbeds, :shortname, :string
    add_column :testbeds, :name, :string
    add_column :testbeds, :urn_prefix_list, :string
    add_column :testbeds, :sessionManagementEndpointUrl, :string
  end
end
