class AddDescToExperiments < ActiveRecord::Migration
  def change
    add_column :experiments, :default_download_config_url, :string
    add_column :experiments, :description, :string
  end
end
