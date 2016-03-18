Factory.define :user do |user|
  user.name                    "Phoenix"
  user.email                   "test@gggmail.com"
  user.password                "123456789"
  user.password_confirmation   "123456789"
end

Factory.sequence :email do |n|
  "phoenix-#{n}@example.com"
end
