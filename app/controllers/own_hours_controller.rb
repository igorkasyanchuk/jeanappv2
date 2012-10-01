class OwnHoursController < SecureController
  belongs_to :project
  
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

  def start_work
    parent.start_work!
  end

  def stop_work
    @time_working = parent.time_working
    parent.stop_work!
  end

  def cancel_work
    parent.stop_work!
  end
  
end
