class ChangingFbidType < ActiveRecord::Migration
  def up
    execute("ALTER TABLE users CHANGE f_id uid BIGINT not null")
  end

  def down
    change_column :users, :uid, :f_id, :float, :null=>false
  end
end
