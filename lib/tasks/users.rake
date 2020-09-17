namespace :users do
  desc "View all users with contact"
  task view: :environment do
    User.find_each do |user|
      puts "#{user.name} - #{user.email} - #{user.phone}"
    end
  end
end
