# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^\"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
  @movies_length = movies_table.hashes.size
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  arg1.split(%r{,\s*}).each do |rating|
      check("ratings_#{rating}")
  end
  click_button('Refresh')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    result=true
    within("tbody") do
       all("tr").each do |tr|
            mResult = false
            arg1.split(%r{,\s*}).each do |rating|
                if !tr.has_content?(rating)
                    mResult = true
                    break
                end
            end
            result = result and mResult
        end  
   end
   expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
    within("tbody") do
        all("tr").size.should == @movies_length
    end
end

When /^I have sorted movies alphabetically$/ do
    click_on("Movie Title")
end

When /^I have sorted movies by date$/ do
    click_on("Release Date")
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |movie1, movie2|
    rows = all("tr")
    expect(rows.index {|x| x.has_content?(movie1)} < rows.index {|x| x.has_content?(movie2)}).to be_truthy
end


