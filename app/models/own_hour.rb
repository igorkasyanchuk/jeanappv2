class OwnHour < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :hours_count
  validates_numericality_of :hours_count
  validates_presence_of :description

  after_create :stop_work_on_project
  
  scope :forward,  order('created_at ASC')
  scope :backward, order('created_at DESC')
  
  scope :by_date, lambda { |date| where(['date(created_at) = date(?)', date])}
  scope :by_projects, lambda { |projects| where(:project_id => projects) }

  def stop_work_on_project
    project.stop_work!
  end
end
