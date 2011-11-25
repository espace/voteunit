class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.float :f_id, :null => false#facebook Id
      t.integer :b_id, :null => false#ballot Id
      t.timestamps
    end
    add_index :users, [:f_id, :b_id]
  end

  def self.down
    drop_table :users
  end
end
