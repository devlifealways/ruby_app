require 'faker'

namespace :db do
  desc "Populate the database"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    #creating an administrator
    administrateur = User.create!(:name => "Level zero",
    :email => "admin@zero.com",
    :password => "careful",
    :password_confirmation => "careful",
    :admin => true)
    administrateur.toggle!(:admin)
    #creating a simple user for the purpose of testing if eveything goes well --> !
    User.create!(:name => "generated user",
    :email => "user@user.com",
    :password => "things",
    :password_confirmation => "things")
    99.times do |n|
      name  = Faker::Name.name
      email = "user-#{n+1}@gmail.com"
      password  = "things"
      User.create!(:name => name,
      :email => email,
      :password => password,
      :password_confirmation => password)
    end
  end
end
