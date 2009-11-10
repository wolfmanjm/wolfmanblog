Then /^I should see "(.*)"$/ do |text|
  webrat_session.response.body.to_s.should =~ /#{text}/m
end

Then /^I should not see "(.*)"$/ do |text|
  webrat_session.response.body.to_s.should_not =~ /#{text}/m
end

Then /^I should see an? (\w+) message$/ do |message_type|
  webrat_session.response.should have_xpath("//*[@class='#{message_type}']")
end

Then /^the (.*) ?request should fail/ do |_|
  webrat_session.response.should_not be_successful
end

Then /^the (.*) ?request should succeed/ do |_|
  webrat_session.response.should be_successful
end

Then /^the request should return status (\d+)$/ do |code|
  webrat_session.response_code.should == code.to_i
end
