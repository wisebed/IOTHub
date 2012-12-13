class AddDownloadPathToExperimentRuns < ActiveRecord::Migration
  def change
    add_column :experiment_runs, :download_config_url, :string
  end
end
