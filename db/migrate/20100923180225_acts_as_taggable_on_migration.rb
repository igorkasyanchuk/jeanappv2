class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end

    create_table :taggings do |t|
      t.references :tag

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true

      t.string :context

      t.datetime :created_at
    end

    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]
    
    Person.all.each do |u|
      puts "Added: #{u.person_role.try(:title)}"
      u.tag_list = u.person_role.try(:title)
      u.save
    end
    drop_table :person_roles
  end

  def self.down
    drop_table :taggings
    drop_table :tags
    create_table :person_roles do |t|
      t.string :title
    end    
  end
end
