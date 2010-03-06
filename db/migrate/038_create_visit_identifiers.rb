class CreateVisitIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :visit_identifiers do |t|
      t.integer :identifier
      t.integer :visit_id
    end
  end

  def self.down
    drop_table :visit_identifiers
  end
end
