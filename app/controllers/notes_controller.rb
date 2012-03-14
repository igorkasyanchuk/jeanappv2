class NotesController < SecureController
  
  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
end