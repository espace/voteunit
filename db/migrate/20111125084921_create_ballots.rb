class CreateBallots < ActiveRecord::Migration
  def self.up
    create_table :ballots do |t|
      t.integer :code, :null => false
      t.string :name, :null => false
      t.string :address, :null => false
      t.float :lng, :null => false
      t.float :lat, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ballots
  end
end
