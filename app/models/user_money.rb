class UserMoney < ActiveRecord::Base
  validates_presence_of :amount
  
  scope :by_date, lambda { |date| where(:date_on => date)}
end