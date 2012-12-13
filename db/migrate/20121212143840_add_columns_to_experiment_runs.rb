class AddColumnsToExperimentRuns < ActiveRecord::Migration
  def change
    add_column :experiment_runs, :user_id, :int
    add_column :experiment_runs, :runtime, :int
    add_column :experiment_runs, :reservation, :string
    add_column :experiment_runs, :failreason, :string
    add_column :experiment_runs, :tb_exp_id, :string
    add_column :experiment_runs, :state, :string
    add_column :experiment_runs, :config_checksum, :string
  end
end
