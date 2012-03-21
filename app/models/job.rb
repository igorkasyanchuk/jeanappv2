class Job < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  belongs_to :user, :foreign_key => :person_id

  attr_protected :state

  validates_presence_of :hours
  validates_presence_of :comment

  before_save :cache_rates

  def cost
    @cost ||= rate * hours
  end

private

  def cache_rates
    self.rate = person.hourly_rate
  end
end