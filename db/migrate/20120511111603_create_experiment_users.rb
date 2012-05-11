class CreateExperimentUsers < ActiveRecord::Migration
  def change
    create_table :experiment_users do |t|

      t.timestamps
    end
  end
end
