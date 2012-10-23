class ExperimentRunData < ActiveRecord::Migration
  def change
    add_column :experiment_runs, :commit, :string
    add_index :experiment_runs, :commit
  end

end
