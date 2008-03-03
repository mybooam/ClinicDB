class AddNotesColumnToPrescriptions < ActiveRecord::Migration
  def self.up
    add_column :prescriptions, :notes, :text
  end

  def self.down
    remove_column :prescriptions, :notes
  end
end
