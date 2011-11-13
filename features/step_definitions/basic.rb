Given /^that I'm not logged in$/ do
  # Don't do anything
end

When /^I hit the home page$/ do
  visit '/'
end

Then /^I should be redirected to a login page$/ do
  #page.driver.status_code.should == 302
  page.driver.status_code.should == 200
  page.should have_content("Login")
end

Given /^that I'm a valid user$/ do
  user = Factory(:user)
  visit '/auth/developer'
end

Then /^I should see a page$/ do
  page.driver.status_code.should == 200
  page.should have_content("Logged in as Test User")
end
