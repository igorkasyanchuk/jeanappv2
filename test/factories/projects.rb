Factory.define :project, :class => Project do |f|
  f.title { Factory.next(:title) }
  f.description { Factory.next(:description) }
  f.started_on "2010-10-10"
  f.budget 500
  f.association :client, :factory => :client 
  f.association :user, :factory => :user 
end