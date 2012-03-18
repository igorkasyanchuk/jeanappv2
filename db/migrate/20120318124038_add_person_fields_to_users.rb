class AddPersonFieldsToUsers < ActiveRecord::Migration
  def self.up
    columns_delta = Person.column_names - User.column_names
    columns_delta.each do |column_name|
      column = Person.columns.find{|person_column| person_column.name == column_name}
      options = {:null => column.null, :default => column.default}
      if column.type == :decimal
        options = options.merge :precision => column.precision, :scale => column.sacle 
      end
      add_column :users, column.name, column.type, options
    end
  end

  def self.down
     ["person_role_id", "title", "skype", "odesk_url", "time_zone", "hourly_rate", "description", "user_id", "country", "city", "dob"].each do |column_name|
       remove_column :users, column_name
     end
  end
end
