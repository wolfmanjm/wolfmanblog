When /^I (DELETE|PUT) (.*) id (\d+)$/ do |method, uri, id|
  @response= request(uri + "/#{id}", :method => method)
end

When /^I POST (.*)$/ do |uri|
  @response= request(uri, :method => 'POST')
end