class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.integer :user_id
      t.string :name
      t.string :skype
      t.string :email
      t.string :web_site
      t.string :phone
      t.string :address
      t.text :description
      t.timestamps
    end
    add_index :clients, :user_id
    add_column :projects, :client_id, :integer
    add_index :projects, :client_id
    add_column :clients, "lat", :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :clients, "lng", :decimal, :precision => 15, :scale => 10, :default => 0.0      
    add_column :clients, :accuracy, :integer, :default => -1
  end

  def self.down
    remove_index :clients, :user_id
    remove_column :projects, :client_id
    remove_index :projects, :client_id
    drop_table :clients
  end
end
