class RemoveRxQuantityAndUnitsColumns < ActiveRecord::Migration
  def self.up
    remove_column :prescriptions, :quantity
    remove_column :prescriptions, :unit
  end

  def self.down
    add_column :prescriptions, :quantity, :float
    add_column :prescriptions, :unit, :string
  end
end
