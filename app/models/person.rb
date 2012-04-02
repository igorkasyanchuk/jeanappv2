class Person < ActiveRecord::Base
  set_table_name 'users'
  include Tmt
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::UrlHelper
	include Rails.application.routes.url_helpers

  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  #default_scope where(:employee => true)

  acts_as_noteable
  acts_as_taggable
  
  has_many :project_staffs, :dependent => :destroy
  has_many :projects, :through => :project_staffs, :uniq => true
  has_many :jobs
  
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :hourly_rate
  
  #validates_presence_of :user_id
  #belongs_to :user
  has_and_belongs_to_many :users, :uniq => true
  
  before_save :geocode_it!, :set_employee_flag!, :set_default_password!

  def name
    "#{self.first_name} #{self.last_name}"
  end
  
  def geocode_it!
    if self.country_changed? || self.city_changed? || self.new_record? && Rails.env =~ /production|development/
      _address = "#{self.country},  #{self.city}"
      logger.info "Geocoding: #{_address}"
      _location = Geokit::Geocoders::MultiGeocoder.geocode(_address)
      if _location.lat && _location.lng && _location.accuracy
        self.lat = _location.lat
        self.lng = _location.lng
        self.accuracy = _location.accuracy
      else
        self.accuracy = -1
      end
    end
    true
  end

  def set_employee_flag!
    employee = true
  end

  def set_default_password!
    password = '123456'
    password_comfirmation = '123456'
  end
  
  def local_time
    (Time.zone.now.in_time_zone(self.time_zone).to_s(:time_12) rescue nil) if self.time_zone
  end
  
  def map_available?
    self.accuracy > 0
  end
  
  def location_info
    { "lat" => self.has_neighbor? ? self.lat + rand() * 2 + rand() * 3: self.lat, 
      "lng" => self.has_neighbor? ? self.lng + rand() * 2 + rand() * 3: self.lng,
      "name" => escape_javascript(self.name), 
      "role" => escape_javascript(self.tag_list.join(', ')),
      "local_time" => self.local_time || 'not set',
      "id" => self.id
    }
  end
  
  def has_neighbor?
    Person.where(:lat => self.lat, :lng => self.lng).count > 1
  end
  
  def workload
    #raise jobs[0].inspect
    _projects = 0
    self.jobs.collect{|ps| ps.project}.uniq.each do |p|
      _projects += 1 unless p.completed?
    end
    _projects
  end

  def jobs_on project
    jobs.where :project_id => project
  end

  def as_user
    becomes User
  end

  def total_hours_on project
    self.jobs_on(project).inject(0) {|sum, e| sum += e.hours }
  end

  def total_money_on project
    self.jobs_on(project).inject(0) {|sum, e| sum += e.cost }
  end
  
end
