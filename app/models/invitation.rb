class Invitation < ActiveRecord::Base
  
  belongs_to :project
  before_save :generate_key, :set_expires_at, :set_initial_password
  after_save :send_email
  validates :email, :presence => true
  validates :rate, :numericality => true

  def generate_key    
    k = []
    15.times do
      k << rand(9)
    end
    self.key = k.join
  end

  def set_initial_password
    k = []
    5.times do
      k << rand(9)
    end
    self.password = k.join
  end

  def send_email
    Invitations.sending_invitation(self).deliver
  end

  def confirm
    @project_owner = User.find project.user_id
    @user = User.create(:email => self.email, :password => self.password, :password_confirmation => self.password, :first_name => self.first_name, :last_name => self.last_name, :address => "Your City", :description => '', :hourly_rate => self.rate)
    @project_owner.people << @user.as_person
    ProjectStaff.create(:person_id => @user.id, :project_id => self.project_id, :description => '')
    destroy
  end

  def set_expires_at
    self.expires_at = Time.now + 14.days
  end

  def actual?
    expires_at >= Time.now
  end


end
