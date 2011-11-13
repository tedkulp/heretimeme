FactoryGirl.define do
  factory :user do
    provider  'developer'
    uid       'test@test.com'
    name      'Test User'
    email     'test@test.com'
  end
end
