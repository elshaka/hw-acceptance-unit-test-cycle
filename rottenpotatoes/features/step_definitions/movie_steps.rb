Given(/^the following movies exist:$/) do |table|
  table.hashes.each { |movie| Movie.create movie }
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |title, director|
  page.should have_content("Director: #{director}")
end
