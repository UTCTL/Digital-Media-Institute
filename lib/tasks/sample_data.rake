namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_skills
  end
end

def make_users
  admin_user = User.create!(:email => "csherrick@austin.utexas.edu",:password => "foobar87", :password_confirmation => "foobar87")
  admin_user.toggle!(:admin)
end

def make_skills
  root_node = Skill.create!(:title => "Digital Media Training" )
  
  site_map = YAML::load(File.open("#{Rails.root}/lib/tasks/site-map.yml"))
  
  traverse_site_map(site_map, root_node)
  
end

def traverse_site_map(node, parent)
  node.each do |key, value|
    new_parent = parent.children.create!(:title => key)
    
    if value.class.to_s == 'Hash'
      traverse_site_map(value,new_parent)
    else
      value.each { |value| new_parent.children.create(:title => value) }
    end
      
  end
end