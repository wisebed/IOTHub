class CreateTestbeds < ActiveRecord::Migration
  def change
    create_table :testbeds do |t|
      t.primary_key :id
      t.string :wiseml_url
      t.timestamps
    end
  end
end
