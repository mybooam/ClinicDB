class AddProcedureNoteToVisit < ActiveRecord::Migration
  def self.up
    add_column :visits, :procedure_note, :text
  end

  def self.down
    remove_column :visits, :procedure_note
  end
end
