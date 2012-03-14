class Note < ActiveRecord::Base
  belongs_to :noteable, :polymorphic => true 
  validates_presence_of :note
  
  scope :forward,  order('notes.created_at ASC')
  scope :backward, order('notes.created_at DESC')   
end
