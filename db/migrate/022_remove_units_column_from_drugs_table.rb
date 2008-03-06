class RemoveUnitsColumnFromDrugsTable < ActiveRecord::Migration
  def self.up
    remove_column :drugs, :units
  end

  def self.down
    add_column :drugs, :units, :string
  end
end
