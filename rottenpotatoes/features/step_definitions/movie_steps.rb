# Add a declarative step here for populating the DB with movies.
def colval(column_name)
  position = "count(//thead/tr/th[text() = '#{column_name}']/preceding-sibling::th) + 1"

  all(:xpath, "//tbody/tr/td[#{position}]").map(&:text)
end

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #fail "Unimplemented"
  titles = colval('Title')
  expect(titles.index(e1)).to be < titles.index(e2),
    "expected '#{e1}' to appears before '#{e2}'"
end

When /I check the following ratings: (.*)/ do |rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(', ').each do |rating|
#    step "I check \"#{rating}\""
    check("ratings_#{rating}")
  end
end
When /I uncheck the following ratings: (.*)/ do |rating_list|
  rating_list.split(', ').each do |rating|
#     step "I uncheck \"#{rating}\""
    uncheck("ratings_#{rating}")
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  expect(colval('Title').size).to eq(Movie.all.count)
end

Then /^I should see the ratings: (.*)/ do |rating_list|
  rating_list.split(', ').each do |rating|
    expect(colval('Rating')).to include rating
  end
end

Then /^I should not see the ratings: (.*)/ do |rating_list|
  rating_list.split(', ').each do |rating|
    expect(colval('Rating')).not_to include rating
  end
end


# When /^I press "(.*)"$/ do |button|
#   click_button button
# end
