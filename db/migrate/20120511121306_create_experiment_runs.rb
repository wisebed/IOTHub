class CreateExperimentRuns < ActiveRecord::Migration
  def change
    create_table :experiment_runs do |t|

      t.timestamps
    end
  end
end
