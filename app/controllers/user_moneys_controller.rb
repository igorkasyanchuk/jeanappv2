class UserMoneysController < SecureController
  belongs_to :user

  def create
    create! do |format|
      format.js {}
    end
  end
  
  def destroy
    destroy! do |format|
      format.js {}
    end
  end

end