class RenameCheifToChief < ActiveRecord::Migration
  def self.up
    rename_column :visits, :cheif_complaint, :chief_complaint
  end

  def self.down
    rename_column :visits, :chief_complaint, :cheif_complaint
  end
end
