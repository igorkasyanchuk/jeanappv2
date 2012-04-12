class User < ActiveRecord::Base
  attr_accessor :require_password
  
  # setup authlogic and use bcrypt to store passwords
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :address, :hourly_rate, :taxes, :user_type

  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address
  
  validates_presence_of :password, :if => :require_password?
  validates_presence_of :password_confirmation, :if => :require_password?
  
  #has_many :people, :dependent => :destroy
  has_and_belongs_to_many :people, :uniq => true

  has_many :projects, :dependent => :destroy
  has_many :clients, :dependent => :destroy
  
  has_many :user_moneys, :dependent => :destroy
  
  has_many :expenses, :through => :projects
  has_many :project_staffs, :through => :projects
  
  has_many :project_participations, :through => :projects, :class_name => 'ProjectStaff', :foreign_key => :person_id, :uniq => true
  has_many :other_projects, :class_name => 'Project', :through => :project_participations, :source => :project
  
  before_save :geocode_it!
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def require_password?
    new_record? || require_password
  end
  
  def geocode_it!
    if self.address_changed? || self.new_record?
      logger.info "Geocoding: #{self.address}"
      _location = Geokit::Geocoders::MultiGeocoder.geocode(self.address)
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
  
  def map_available?
    self.accuracy > 0
  end
  
  def location_info
    { "lat" => self.lat, "lng" => self.lng, "name" => self.name }.to_json
  end
  
  def people_info
    self.people.collect{|p| p.location_info}
  end
  
  def clients_info
    self.clients.collect{|p| p.location_info}
  end
  
  def my_taxes
    self.taxes || 0
  end
  
  def time_report_on_date(date)
    ids = self.project_ids
    mine = OwnHour.by_projects(ids).by_date(date).sum(:hours_count)
    contractors = ProjectStaff.by_projects(ids).by_date(date).sum(:hours_count)
    [mine, contractors]
  end

  def as_person
    becomes Person
  end

  def owner?
    self.user_type == 'owner'
  end

  def employee?
    !self.owner?
  end

end
