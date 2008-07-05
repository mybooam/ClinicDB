class AddSoapNoteToVisitTable < ActiveRecord::Migration
  def self.up
    add_column :visits, :subjective_note, :text
    add_column :visits, :objective_note, :text
    add_column :visits, :assessment_note, :text
    add_column :visits, :plan_note, :text
  end

  def self.down
    remove_column :visits, :subjective_note
    remove_column :visits, :objective_note
    remove_column :visits, :assessment_note
    remove_column :visits, :plan_note
  end
end
