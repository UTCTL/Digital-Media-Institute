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
    role "user"

    factory :admin_user do
      role "admin"
    end
  end
  
  
  
  factory :lesson do
    title "Beginner Photoshop Getting Started"
    content "In the beginning there was photoshop"
    kind "Video"
    link "http://vimeo.com/32001208"
  end
  
  factory :challenge do
    sequence(:title) {|n| "Challenge #{n}"}
    content "This is a really hard challenge"
  end
end
