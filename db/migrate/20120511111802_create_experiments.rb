class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|

      t.timestamps
    end
  end
end
