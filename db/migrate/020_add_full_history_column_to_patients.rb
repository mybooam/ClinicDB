class AddFullHistoryColumnToPatients < ActiveRecord::Migration
  def self.up
    add_column :patients, :history_taken, :boolean
  end

  def self.down
    remove_column :patients, :history_taken
  end
end
