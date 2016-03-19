Factory.define :user do |user|
  user.name                    "Phoenix"
  user.email                   "admin@zero.com"
  user.password                "careful"
  user.password_confirmation   "careful"
end

Factory.sequence :email do |n|
  "phoenix-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Phoenix say's hello ! "
  micropost.association :user
end
