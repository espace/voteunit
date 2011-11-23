class CreateBallots < ActiveRecord::Migration
  def up
    create_table :ballots do |t|
      t.integer :code, :null => false
      t.string :name, :null => false
      t.string :address, :null => false
      t.float :lng, :null => false
      t.float :lat, :null => false
      t.timestamps
    end
  end
  
  def down
    drop_table :ballots
  end
end
