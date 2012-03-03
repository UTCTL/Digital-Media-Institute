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

  factory :submission do
    user_id  1

    factory :image_submission do
      media_type 'image'
      attachment 'images/test.jpg'
    end

    factory :video_submission do
      media_type 'video'
      link 'http://www.vimeo.com/1234'
    end

    factory :link_submission do
      media_type 'link'
      link 'http://www.cnn.com'
    end
  end
end
