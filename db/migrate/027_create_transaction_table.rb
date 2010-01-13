class CreateTransactionTable < ActiveRecord::Migration
  def self.up
    create_table :transaction, :engine => :InnoDB do |t|
      t.column :user_id, :integer, :null => false
      t.column :type, :string, :null => false
      t.column :record_type, :string, :null => false
      t.column :record_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :transaction
  end
end
