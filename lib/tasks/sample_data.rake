require 'faker'

# namespace :db do
#   desc "Populate the database"
#   task :populate => :environment do
#     Rake::Task['db:reset'].invoke
#     #creating an administrator
#     administrateur = User.create!(:name => "Level zero",
#     :email => "admin@zero.com",
#     :password => "careful",
#     :password_confirmation => "careful",
#     :admin => true)
#     administrateur.toggle!(:admin)
#     #creating a simple user for the purpose of testing if eveything goes well --> !
#     User.create!(:name => "generated user",
#     :email => "user@user.com",
#     :password => "things",
#     :password_confirmation => "things")
#     99.times do |n|
#       name  = Faker::Name.name
#       email = "user-#{n+1}@gmail.com"
#       password  = "things"
#       User.create!(:name => name,
#       :email => email,
#       :password => password,
#       :password_confirmation => password)
#     end # 99.times
#     User.all(:limit => 6).each do |user|
#       50.times do
#         user.microposts.create!(:content => Faker::Lorem.sentence(5))
#       end
#     end #all
#   end #task
# end #namespace


# the new version

namespace :db do
  desc "populate the databse with dump data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end


def make_users
  admin = User.create!(:name => "Generated User",
                       :email => "user@railsknowledge.org",
                       :password => "things",
                       :password_confirmation => "things")
  # makes the user an admin
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "user-#{n+1}@railsknowledge.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end #make_users

def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end #make microposts

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end #make relationships
