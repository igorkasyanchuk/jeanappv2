class ProjectStaff < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  validates_presence_of :description
  validates_presence_of :hours_count
  validates_numericality_of :hours_count
  
  scope :forward,  order('project_staffs.created_at ASC')
  scope :backward, order('project_staffs.created_at DESC')
  scope :since,    lambda { |time| where('project_staffs.created_at >= ?', time) }
  scope :before,   lambda { |time| where('project_staffs.created_at < ?',  time) }
  scope :by_date, lambda { |date| where(['date(created_at) = date(?)', date])}
  scope :by_projects, lambda { |projects| where(:project_id => projects) }
  
  before_save :set_rate
  
  def set_rate
    self.hourly_rate = self.person.hourly_rate
  end

  def amount
    self.hours_count * self.hourly_rate
  end

end