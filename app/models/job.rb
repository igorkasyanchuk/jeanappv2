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

  def unupprove
    update_attribute :state, 'pending' if approved?
  end

  def approve
    update_attribute :state, 'approved' if pending? || paid?
  end

  def pay
    update_attribute :state, 'paid' if approved?
  end

  def next_state
    if pending?
      approve
    elsif approved?
      pay
    else
      false
    end
  end

  def prev_state
    if payed?
      approve
    elsif approved?
      unupprove
    else
      false
    end
  end



  %w{pending approved paid}.each do |state_value|
    define_method "#{state_value}?" do
      state == state_value
    end
  end

private

  def cache_rates
    self.rate ||= person.hourly_rate
  end
end
