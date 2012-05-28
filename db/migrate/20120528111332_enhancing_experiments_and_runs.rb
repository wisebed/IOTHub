class EnhancingExperimentsAndRuns < ActiveRecord::Migration
  def change
    add_column :experiments, :name, :string, :null => false, :default => "awesome but unnamed experiment"
    add_column :experiments, :user_id, :id, :null => false, :default => 0
    add_column :experiments, :visibility, :string, :null => false, :default => "private"
    
    add_column :experiment_runs, :experiment_id, :id, :null => false, :default => 0
  end
  
end
