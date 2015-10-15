FactoryGirl.define do
  factory :user do
    email 'test@email.com'
    password 'password'
    password_confirmation 'password'
  end

  factory :user2, class: User do
    email 'test2@email.com'
    password 'password'
    password_confirmation 'password'
  end
end
