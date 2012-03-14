class RemoveFieldFromPerson < ActiveRecord::Migration

  def self.up
    remove_column :people, :aim
    remove_column :people, :jabber
    add_column :people, :country, :string
    add_column :people, :city, :string
    add_column :people, :dob, :date
  end

  def self.down
    add_column :people, :aim, :string
    add_column :people, :jabber, :string
    remove_column :people, :country
    remove_column :people, :city
    remove_column :people, :dob
  end

end
