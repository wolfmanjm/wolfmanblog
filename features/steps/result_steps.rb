Then /^I should see "(.*)"$/ do |text|
  response_body.to_s.should =~ /#{text}/m
end

Then /^I should not see "(.*)"$/ do |text|
  response_body.to_s.should_not =~ /#{text}/m
end

Then /^I should see an? (\w+) message$/ do |message_type|
  @response.should have_xpath("//*[@class='#{message_type}']")
end

Then /^the (.*) ?request should fail/ do |_|
  @response.should_not be_successful
end

Then /^the (.*) ?request should succeed/ do |_|
  @response.should be_successful
end

Then /^the (.*) ?request should return status (\d+)/ do |_, status|
  @response.status.should == status.to_i
end

Then /^the (.*) ?request should redirect to (.*)$/ do |_, uri|
  @response.should redirect_to(uri)
end
