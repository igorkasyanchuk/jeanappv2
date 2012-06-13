class Job < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  belongs_to :user, :foreign_key => :person_id

  attr_protected :state

  validates :rate, :presence => true, :numericality => true
  validates_presence_of :hours
  validates_presence_of :comment

  before_save :cache_rates

  scope :forward,  order('jobs.created_at ASC')
  scope :backward, order('jobs.created_at DESC')
  scope :since,    lambda { |time| where('jobs.created_at >= ?', time) }
  scope :before,   lambda { |time| where('jobs.created_at < ?',  time) }
  scope :by_date, lambda { |date| where(['date(created_at) = date(?)', date])}
  scope :by_user, lambda {|user| where(:person_id => user.id)} 
  scope :pending, where(:state => 'pending')
  scope :approved, where(:state => 'approved')
  scope :paid, where(:state => 'paid')
  scope :pending_or_approved, where(:state => ['pending', 'approved'])
  scope :by_month, lambda { |date| where(:created_at => date.beginning_of_month..date.end_of_month) }  
  scope :by_projects, lambda { |projects| where(:project_id => projects) }

  def cost
    @cost ||= rate * hours
  end

  alias_method :amount, :cost

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
