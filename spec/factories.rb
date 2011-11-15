FactoryGirl.define do
  factory :user do
    provider  'developer'
    uid       'test@test.com'
    name      'Test User'
    email     'test@test.com'
  end

  factory :project do
    name "Test Project"
  end

  factory :timer do
    start_time nil 
    end_time nil
    current_start_time nil
    current_end_time nil
    total_time_in_sec 0
    state 'stopped'
  end
end
