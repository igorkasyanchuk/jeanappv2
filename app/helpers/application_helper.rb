module ApplicationHelper
  include CalendarHelper
  
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << "<div class='#{msg} flash'>#{html_escape(flash[msg.to_sym])}</div>" unless flash[msg.to_sym].blank?
    end
    flash.clear
    messages.join.html_safe
  end
  
  def inside_layout(layout = 'application', &block) 
    render :inline => capture_haml(&block), :layout => "layouts/#{layout}" 
  end
  
  def yield_or_default(message, default_message = "")
    message.nil? ? default_message : message
  end
  
  def title(t = 'P2P')
    content_for :title do
      t
    end
  end
  
  def sortable(column, title = nil, options = {}, m = :sort_column)
    title ||= column.titleize
    css_class = column == send(m) ? "current #{sort_direction}" : nil
    direction = column == send(m) && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}.merge(options), :class => css_class
  end
  
  def add_google_map
    content_for :map do
      '<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>'
    end
  end
  
  def add_google_table_chart
    result =<<BASE
    <script type='text/javascript' src='http://www.google.com/jsapi'></script>
    <script type='text/javascript'>
      google.load('visualization', '1', {'packages':['corechart']});
    </script>
BASE
    result.html_safe
  end
  
  def money_calendar_cell(day)
    value = current_user.user_moneys.by_date(day).sum(:amount)
    sign_class = value > 0 ? 'plus_sign' : 'minus_sign'
    sign = '+' if value > 0 
    sign_class = 'zero_sign' if value == 0
    day_calendar_form = (render :partial => '/calendars/cell_form', :locals => { :day => day})
    cell = "<div class='day_id'>#{day.mday}</div><span class='#{sign_class}'>#{sign}#{number_to_currency(value, :precision => 2).gsub('.00', '').gsub('$-', '-$')}</span>"
    [cell + day_calendar_form, {:class => "day", "data-day-id" => day}]
  end
    
  def money_calendar(year = nil, month = nil)
    year = year || params[:year].try(:to_i) || Time.now.year
    month = month || params[:month].try(:to_i) || Time.now.month
    now        = Date.new(year, month)
    prev_month = now << 1
    next_month = now >> 1
    prev_month_link = (link_to 'Previous Month'.html_safe, user_calendars_path(current_user, :month => prev_month.month, :year => prev_month.year))
    next_month_link = (link_to 'Next Month'.html_safe, user_calendars_path(current_user, :month => next_month.month, :year => next_month.year), :class => 'next')
    calendar :abbrev => (0..-1), :year => now.year, :month => now.month,
      :previous_month_text => prev_month_link, :next_month_text => next_month_link do |d|
        money_calendar_cell(d)
    end
  end
  
  def time_calendar_cell(day)
    time_report = current_user.time_report_on_date(day)
    day_calendar_form = (render :partial => '/time_reports/cell_form', :locals => { :day => day})
    cell = "<div class='day_id'>#{day.mday}</div><span class='time_cell'>#{time_report[0].to_s.gsub('0.0', '0')} / #{time_report[1].to_s.gsub('0.0', '0')}</span>"
    [cell + day_calendar_form, {:class => "day", "data-day-id" => day}]
  end
    
  def time_calendar(year = nil, month = nil)
    year = year || params[:year].try(:to_i) || Time.now.year
    month = month || params[:month].try(:to_i) || Time.now.month
    now        = Date.new(year, month)
    prev_month = now << 1
    next_month = now >> 1
    prev_month_link = (link_to 'Previous Month'.html_safe, user_time_reports_path(current_user, :month => prev_month.month, :year => prev_month.year))
    next_month_link = (link_to 'Next Month'.html_safe, user_time_reports_path(current_user, :month => next_month.month, :year => next_month.year), :class => 'next')
    calendar :abbrev => (0..-1), :year => now.year, :month => now.month,
      :previous_month_text => prev_month_link, :next_month_text => next_month_link do |d|
        time_calendar_cell(d)
    end
  end


end
