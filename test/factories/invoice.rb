Factory.define :invoice, :class => Invoice do |f|
  f.association :project, :factory => :project
  f.hours_count 10.0
  f.hourly_rate 15.0
  f.description "Description"
end