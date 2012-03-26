class Invitation < ActiveRecord::Base
  
  belongs_to :project
  before_save :generate_key
  after_save :send_email
  validates :email, :presence => true
  #validates :rate, :numericality => true

  def generate_key    
    k = []
    15.times do
      k << rand(9)
    end
    self.key = k.join
  end

  def send_email
    Invitations.sending_invitation(self).deliver
  end

  def confirm_inv
    @user = User.create(:user_id => project.user_id, :email => self.email, :password => '123456', :password_confirmation => '123456', :first_name => self.first_name, :last_name => self.last_name, :address => "Your City", :description => '', :hourly_rate => self.rate)
    ProjectStaff.create(:person_id => @user.id, :project_id => self.project_id, :description => '')
  end


end
