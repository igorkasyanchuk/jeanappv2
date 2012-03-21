class JobsController < SecureController
  #belongs_to :project
  
  def create
    create!  do |format|
      format.js {}
    end
  end
  
  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
end
