When /^I (DELETE|PUT) (.*) id (\d+)$/ do |method, uri, id|
  @response= visit(uri + "/#{id}", method.downcase.to_sym)
end

When /^I POST (.*)$/ do |uri|
  @response= visit(uri, :post)
end