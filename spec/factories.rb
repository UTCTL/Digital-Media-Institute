FactoryGirl.define do
  factory :skill do
    sequence(:title) {|n| "Skill #{n}"}
    description "this is only a test, yo!"
  end
  
  factory :user do
    first_name "Scotty"
    last_name "H"
    sequence(:email) {|n| "user#{n}@example.com"}
    password "foobar87"
    password_confirmation "foobar87"
    
    factory :admin_user do
      admin true
    end
  end
  
  
  
  factory :lesson do
    title "Beginner Photoshop Getting Started"
    content "In the beginning there was photoshop"
    kind "Video"
    link "http://vimeo.com/32001208"
  end
  
  factory :challenge do
    title "Challenge #1"
    content "This is a really hard challenge"
  end
end