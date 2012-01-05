FactoryGirl.define do
  factory :skill do
    title "Test Skill"
    description "this is only a test, yo!"
  end
  
  factory :lesson do
    title "Beginner Photoshop Getting Started"
    content "In the beginning there was photoshop"
    kind "Video"
    link "http://vimeo.com/32001208"
    list_scope 1
  end
  
  factory :challenge do
    title "Challenge #1"
    content "This is a really hard challenge"
  end
end