class SecureController < InheritedResources::Base
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::NumberHelper

  respond_to :html, :xml, :json

  before_filter :require_user
  before_filter :check_user_permissions

  layout 'admin'

  helper_method :refresh_diagram
  helper_method :clear_fields
  helper_method :update_project_details

  private

    def refresh_diagram(project)
      script =<<EOF
$.colorbox.close();
setTimeout("refreshChart([#{project.profit},#{project.amount_total},#{project.project_expenses}], '#{escape_javascript(project.title)}');", 200);
EOF
      script.html_safe
    end

    def clear_fields
      script =<<EOF
        $('form.formtastic input[type=text], form.formtastic textarea').val('');
EOF
      script.html_safe
    end

    def update_project_details(project)
      script =<<EOF
        $ee = "#{escape_javascript((render '/projects/_info', :locals => {:project => project}).join)}";
        $('#info').html($ee);
        show_money_chart(#{@project.money_chart.to_json});
        show_time_chart(#{@project.time_chart.to_json});
EOF
      script.html_safe
    end

    def check_user_permissions
      if params[:user_id]
        if current_user != User.find_by_id(params[:user_id])
          flash[:notice] = "You don't have permissions to that page."
          redirect_to user_projects_path(current_user)
        end
      end
    end

end
