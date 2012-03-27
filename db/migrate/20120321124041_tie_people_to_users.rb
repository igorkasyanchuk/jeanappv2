class TiePeopleToUsers < ActiveRecord::Migration
  def self.up
    Person.where('user_id is not NULL').each do |person|
      User.find(person.user_id).people << person
    end
  end

  def self.down
  end
end
