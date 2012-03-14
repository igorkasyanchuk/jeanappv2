class Expense < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :amount
  validates_presence_of :description
  validates_numericality_of :amount
  
  scope :forward,  order('expenses.created_at ASC')
  scope :backward, order('expenses.created_at DESC')
  scope :since,    lambda { |time| where('expenses.created_at >= ?', time) }
  scope :before,   lambda { |time| where('expenses.created_at < ?',  time) }

end
