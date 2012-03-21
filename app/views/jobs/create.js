$("#jobs_<%=escape_javascript("#{@job.project.id}")%>")
  .html("<%= escape_javascript(render :partial => 'jobs', :locals => {:project => @job.project})%>");