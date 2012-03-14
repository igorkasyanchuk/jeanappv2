Factory.define :client, :class => Client do |f|
  f.name { Factory.next(:name) }
  f.association :user, :factory => :user
end