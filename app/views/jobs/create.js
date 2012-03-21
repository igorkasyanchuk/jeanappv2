$("#jobs_<%=escape_javascript("#{@job.project.id}")%>")
  .html("<%= escape_javascript(render :partial => 'jobs/jobs', :locals => {:project => @job.project})%>");