class PeopleController < SecureController
  helper_method :sort_column, :sort_direction
  
  belongs_to :user

  def index
    _people = params[:tag].blank? ? current_user.people : current_user.people.tagged_with(params[:tag])
    if params[:sort] == 'local_time'
      @people = _people.all.sort{|a, b| a.local_time <=> b.local_time}
      @people.reverse! if params[:direction] == 'desc'
    elsif params[:sort] == 'workload'
      @people = _people.all.sort{|a, b| a.workload <=> b.workload}
      @people.reverse! if params[:direction] == 'desc'
    else
      @people = _people.order(sort_column + " " + sort_direction)
    end
    @tags = current_user.people.tag_counts_on(:tags)
  end

  def create
    params[:person] = params[:person].merge :password => 111111, :password_confirmation => 111111
    #raise params[:person].inspect
    super
    @person.users << current_user unless @person.new_record?
  end
  
  private
  
    def sort_column
      Person.column_names.include?(params[:sort]) ? params[:sort] : (params[:sort] =~ /local_time|workload/ ? params[:sort] : "first_name")
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end  
  
end
