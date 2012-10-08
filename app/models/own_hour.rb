class OwnHour < ActiveRecord::Base
  attr_accessor :duration
  belongs_to :project
  
  validates :duration, :presence => true, :format => {:with => /\d{2}:\d{2}:\d{2}|\d*\.?\d*?/}

  #validates_numericality_of :hours_count
  validates_presence_of :description

  after_validation :duration_to_hours_count
  after_create :stop_work_on_project
  
  scope :forward,  order('created_at ASC')
  scope :backward, order('created_at DESC')
  
  scope :by_date, lambda { |date| where(['date(created_at) = date(?)', date])}
  scope :by_projects, lambda { |projects| where(:project_id => projects) }

  def stop_work_on_project
    project.stop_work!
  end

  private
  def duration_to_hours_count
    d = @duration.split(':')
    if d.size > 2
      self.hours_count = ((d[0].to_f * 3600 + d[1].to_f * 60 + d[2].to_f) / 3600).round(1)
    else
      self.hours_count = @duration.to_f
    end
  end
end
