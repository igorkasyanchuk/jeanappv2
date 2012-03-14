class Client < ActiveRecord::Base
  include Tmt
  validates_presence_of :name
  #validates_presence_of :email
  #validates_presence_of :address

  belongs_to :user
  has_many :projects

  acts_as_noteable

  scope :order_by_name, order('name')

  #before_save :geocode_it!

  def geocode_it!
    if self.address_changed? || self.new_record? && Rails.env =~ /production|development/
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
  
  def empoyees_count
    self.projects.inject(0) {|sum,p| sum += p.people.count }
  end  
  
  def location_info
    { "lat" => self.lat, "lng" => self.lng, "name" => self.name, "local_time" => self.local_time || 'not set', "id" => self.id }
  end
  
  def local_time
    (Time.zone.now.in_time_zone(self.time_zone).to_s(:time_12) rescue nil) if self.time_zone
  end  
  
end