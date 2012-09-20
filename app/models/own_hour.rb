class OwnHour < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :hours_count
  validates_numericality_of :hours_count
  validates_presence_of :description

  after_create :drop_project_work_started_at
  
  scope :forward,  order('created_at ASC')
  scope :backward, order('created_at DESC')
  
  scope :by_date, lambda { |date| where(['date(created_at) = date(?)', date])}
  scope :by_projects, lambda { |projects| where(:project_id => projects) }

  def drop_project_work_started_at
    project.update_attribute :work_started_at, nil
  end
end
