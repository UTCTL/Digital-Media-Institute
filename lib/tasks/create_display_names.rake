namespace :db do
  desc "Creates display names form first and last name"
  task :create_display_names => :environment do 
    User.all.each do |user|
      user.update_attributes :display_name => "#{user.first_name}_#{user.last_name}".downcase
    end

  
  end
end
