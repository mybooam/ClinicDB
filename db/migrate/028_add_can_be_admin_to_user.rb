class AddCanBeAdminToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :can_be_admin, :boolean, :null=>false, :default => false
  end

  def self.down
    remove_column :users, :can_be_admin
  end
end