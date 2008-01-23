class CreateFamilyHistoryChoices < ActiveRecord::Migration
  def self.up
    create_table :family_history_choices, :engine => :InnoDB do |t|
      t.column :name, :string, :null => false
		t.timestamps
    end
  end

  def self.down
    drop_table :family_history_choices
  end
end
