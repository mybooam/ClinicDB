class CreateLivingArrangements < ActiveRecord::Migration
  def self.up
    create_table :living_arrangements do |t|
      t.string :name

      t.timestamps
    end
    
    LivingArrangement.create( :name => 'Unknown')
    LivingArrangement.create( :name => 'Homeless')
    LivingArrangement.create( :name => 'Group Home')
    LivingArrangement.create( :name => 'Has Home')
    LivingArrangement.create( :name => 'Other')

  end

  def self.down
    drop_table :living_arrangements
  end
end
