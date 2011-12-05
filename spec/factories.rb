FactoryGirl.define do
  factory :skill do
    title "Test Skill"
    description "this is only a test, yo!"
  end
  
  factory :lesson do
    title "Beginner Photoshop Getting Started"
    content "In the beginning there was photoshop"
    list_scope 1
  end
end