# creates n posts
Given /^(\d+) posts exist$/ do |n|
  @dbhelper.truncate(:posts)
  for i in (1..n.to_i) do
    @dbhelper.add_post(:id => i, :title => "post #{i}", :body => "body of post #{i}")
  end
end

Then /^I should see post (\d+)$/ do |n|
  @response.should have_xpath("//h2/a[@href='/posts/#{n}']['post #{n}']")
  @response.should have_selector("p:contains('body of post #{n}')")
end

Then /^I should not see post (\d+)$/ do |n|
  @response.should_not have_xpath("//h2/a[@href='/posts/#{n}']")
end
