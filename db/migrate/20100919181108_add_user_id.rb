class AddUserId < ActiveRecord::Migration
  def self.up
    user = User.create(:email => 'mail@rosem.com', :password => '123456', :password_confirmation => '123456', :first_name => "Mike", :last_name => 'Rose')
    add_column :projects, :user_id, :integer
    add_column :people, :user_id, :integer
    add_column :person_roles, :user_id, :integer
    [Project, Person, PersonRole].each do |klass|
      klass.reset_column_information
      klass.all.each do |o|
        o.user_id = user.id
        o.save
      end
    end
  end

  def self.down
    User.destroy_all
    remove_column :projects, :user_id
    remove_column :people, :user_id
    remove_column :person_roles, :user_id
  end
end
