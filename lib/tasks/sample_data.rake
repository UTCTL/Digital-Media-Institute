namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_skills
  end
end

def make_users
  User.create!(:email => "csherrick@austin.utexas.edu",:password => "foobar87", :password_confirmation => "foobar87")
end

def make_skills
  root_node = Skill.create!(:title => "Digital Media Training" )
  
  design_node = root_node.children.create!(:title => "Design")
  
  ps_node = design_node.children.create!(:title => "Photoshop")
    ps_node.children.create!(:title => "Beginner")
    ps_node.children.create!(:title => "Intermediate")
    ps_node.children.create!(:title => "Advanced")
  
  il_node = design_node.children.create!(:title => "Illustrator")
    il_node.children.create!(:title => "Beginner")
    il_node.children.create!(:title => "Intermediate")
    il_node.children.create!(:title => "Advanced")
  
  web_node = root_node.children.create!(:title => "HTML/CSS")
  motion_node = root_node.children.create!(:title => "Motion")
  three_d_node = root_node.children.create!(:title => "3D")
  mobile_node = root_node.children.create!(:title => "Mobile")
end