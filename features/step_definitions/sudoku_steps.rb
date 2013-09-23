Then(/^I should see a puzzle$/) do
  page.assert_selector('input', :count => 81)
end

When(/^I fill in an empty square with '(\d+)'$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the empty square should contain '(\d+)'$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end