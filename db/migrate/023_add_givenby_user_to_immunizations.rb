class AddGivenbyUserToImmunizations < ActiveRecord::Migration
  def self.up
    add_column :immunizations, :givenby_user_id, :integer
  end

  def self.down
    remove_column :immunizations, :givenby_user_id
  end
end
