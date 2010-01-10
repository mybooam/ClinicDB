class AddAccessCodeHashToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :access_hash, :string
  end

  def self.down
    remove_column :users, :access_hash
  end
end
