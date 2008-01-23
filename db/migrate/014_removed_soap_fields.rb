class RemovedSoapFields < ActiveRecord::Migration
  def self.up
    remove_column :visits, :assessment
  end

  def self.down
    add_column :visits, :assessment, :text
  end
end
