class ExperimentRuns < ActiveRecord::Migration
  def change
    add_column :experiment_runs, :experiment_version, :string
    add_column :experiment_runs, :experiment_data_host, :string
    add_column :experiment_runs, :experiment_data_path, :string
    add_column :experiment_runs, :testbed_id, :id
    add_column :experiment_runs, :start_time, :datetime
    add_column :experiment_runs, :finish_time, :datetime
  end
end
