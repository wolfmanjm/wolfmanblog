# creates n posts
Given /^(\d+) posts exist$/ do |n|
  @dbhelper.truncate(:posts)
  for i in (1..n.to_i) do
    @dbhelper.add_post(:id => i, :title => "post #{i}", :body => "body of post #{i}", :permalink => "post-#{i}")
  end
end

Then /^I should see post (\d+)$/ do |n|
  y= Time.now.year
  m= Time.now.month
  d= Time.now.day
  @response.should have_xpath("//h2/a[@href='/articles/#{y}/#{m}/#{d}/post-#{n}']['post #{n}']")
  @response.should have_selector("p:contains('body of post #{n}')")
end

Then /^I should not see post (\d+)$/ do |n|
  @response.should_not have_selector("p:contains('body of post #{n}')")
end

Then /^I should see only post (\d+)$/ do |n|
  @response.should have_selector("div.post h2:contains('post #{n}')")
  @response.should have_selector("p:contains('body of post #{n}')")
  @response.should have_selector("form.commentform")
end

When /^I leave an? (in)?valid comment$/ do |t|
  When 'I fill in "comment[name]" with "comment-user"'
  And 'I fill in "comment[body]" with "my comment message"'
  And 'I fill in "test" with ' + (t.nil? ? '"no"' : '"blahblahblah"')
  And 'I press "Submit"'
end

Then /^I should (not)? ?see the comment$/ do |t|
  comment_user= "ol.comment-list li.comment cite strong:contains('comment-user')"
  comment_body= "ol.comment-list li.comment:contains('my comment message')"
  if t.nil?
    @response.should have_selector(comment_user)
    @response.should have_selector(comment_body)
  else
    @response.should_not have_selector(comment_user)
    @response.should_not have_selector(comment_body)
  end
end
