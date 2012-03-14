class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :noteable_id
      t.string :noteable_type
      t.text :note
      t.timestamps
    end
    add_index :notes, [:noteable_id, :noteable_type]
  end

  def self.down
    remove_index :notes, [:noteable_id, :noteable_type]
    drop_table :notes
  end
end
