Factory.define :person, :class => Person do |f|
  f.first_name { Factory.next(:first_name) }
  f.last_name { Factory.next(:last_name) }
  f.email { Factory.next(:email) }
  f.hourly_rate 15
  f.skype 'skype'
  f.association :user, :factory => :user
end