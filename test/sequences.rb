Factory.sequence :email do |n|
  "person#{n}@example.com"
end

Factory.sequence :address do |n|
  "Address, street, building #{n}"
end

Factory.sequence :city_name do |n|
  "City Name #{n}"
end

Factory.sequence :company_name do |n|
  "Company Name #{n}"
end

Factory.sequence :first_name do |n|
  "First Name #{n}"
end

Factory.sequence :last_name do |n|
  "Last Name #{n}"
end

Factory.sequence :name do |n|
  "Name #{n}"
end

Factory.sequence :title do |n|
  "Title #{n}"
end

Factory.sequence :country do |n|
  "Country #{n}"
end

Factory.sequence :description do |n|
  "Description #{n}"
end

Factory.sequence :body do |n|
  "Body #{n}"
end

Factory.sequence :author do |n|
  "Author #{n}"
end

Factory.sequence :state_name do |n|
  "State Name #{n}"
end

Factory.sequence :country_name do |n|
  "Country Name #{n}"
end

Factory.sequence :language_name do |n|
  "Language #{n}"
end

Factory.sequence :phone_number do |n|
  ["#{n}5-99-11", "#{n}1-22-33", "#{n}2-88-33"].rand
end