Given /^I am not authenticated$/ do
  response= visit '/logout'
  response.should be_successful
end

Given /^a valid user account exists$/ do
  @dbhelper.truncate(:users)
  # do this instead of using fixtures
  # eventually we can do this
#  Given 'The database contains:', table(%{
#    | table | column           | value                                    |
#    | users | name             | testname                                 |
#    | users | crypted_password | 12f0d0cf9d59500b89677e3f9f037aaa993979dc |
#    | users | salt             | 46ca4885db7cd09121ef4d9c7ba2af13de40ff9e |
#  })
  # but for now we have to do it the hard way
  @dbhelper.add_user('testname', '12f0d0cf9d59500b89677e3f9f037aaa993979dc', '46ca4885db7cd09121ef4d9c7ba2af13de40ff9e')
end

When 'I login' do
  When  'I go to /login'
  And 'I fill in "name" with "testname"'
  And 'I fill in "password" with "testpassword"'
  And 'I press "Log In"'
end

Then /^I should see logged in message$/ do
  @response.should have_xpath("//*[@class='logged-in']")
  response_body.to_s.should =~ /logged in as testname/i
end

