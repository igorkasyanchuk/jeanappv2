class EarningsController < SecureController
  belongs_to :user
  
  def index
    _info, _result = [], [] 
    @start = Date.parse(params[:start]) rescue Time.now - 2.months
    @end = Date.parse(params[:end]) rescue Time.now + 1.week
    @step, @start, @end = params['filter'] && params['filter'] == 'month' ?   [1.month, @start.beginning_of_month, @end.end_of_month]   :   [1.week, @start.beginning_of_week.monday, @end.beginning_of_week.monday]
    params[:start], params[:end] = @start.strftime("%Y-%m-%d"), @end.strftime("%Y-%m-%d")
    while (@start <= @end) do
      till_date = @start + @step
      projects = current_user.projects.completed.since(@start).before(till_date).all
      r = {}
      r[:week] = @start.strftime("%Y/%m/%d")
      r[:profit] = projects.inject(0) {|sum, p| sum += p.profit }
      r[:budget] = projects.inject(0) {|sum, p| sum += p.cached_budget }
      r[:paid] = current_user.project_staffs.since(@start).before(till_date).all.inject(0) {|sum, p| sum += p.amount }
      r[:expenses] = current_user.expenses.since(@start).before(till_date).all.inject(0) {|sum, p| sum += p.amount }
      _result << r
      @start = till_date
    end
    _result.each do |e|
      _info << [ e[:week], e[:profit], e[:budget], e[:paid], e[:expenses] ]
    end
    @info = _info
    @earnings = _info.collect{|e|  "['#{e[0]}', #{e[1]}, #{e[2]}, #{e[3]}, #{e[4]}]" }.join(',')
  end

end
