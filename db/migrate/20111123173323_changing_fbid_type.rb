class ChangingFbidType < ActiveRecord::Migration
  def up
    execute("ALTER TABLE users CHANGE f_id f_id BIGINT not null")
  end

  def down
    if User.new.respond_to? :uid
      change_column :users, :uid, :float, :null=>false
      rename_column :users, :uid, :f_id
    else
      change_column :users, :f_id, :float, :null=>false
    end

  end
end
