Given %r{^There are multiple collections in the system$} do
  my.collection = repository.collection(user: my.user)
  their.user = repository.user
  their.collections << repository.collection(user_id: their.user.id)
  their.collections << repository.collection(user_id: their.user.id)
end

Given %r{^I see just my collections$} do
  page.should have_css(".app-collection-#{my.collection.id}")
  page.all('.app-view-collection').count.should == 1
end

When %r{^I view my collections$} do
  visit "/settings/collections"
end

When %r{^I visit my followed users$} do
  visit "/settings/following"
end

Given %r{^I visit all collections$} do
  visit '/collections'
end

Given %r{^I see all collections$} do
  page.should have_css(".app-collection-#{my.collection.id}")
  their.collections.each do |collection|
    page.should have_css(".app-collection-#{collection.id}")
  end
end

Given %r{^I create a collection$} do
  visit "/settings/collections"
  page.find('.app-new-collection').click
  fill_in "collection-name", with: 'The big collection of things'
  fill_in "collection-description", with: 'Stories of elephants and blimps'
  page.find('.app-save').click
end

Given %r{^I see the new collection in my collections$} do
  page.should have_css('.app-full-collection')
  visit_profile_for my.user
  page.should have_css('.app-view-collection')
  page.should have_content('The big collection of things')
end

Given %r{^I have a collection$} do
  my.collection = repository.collection
end

Given %r{^I delete my collection$} do
  visit "/settings/collections"
  page.find(".app-collection-#{my.collection.id}").click
  page.find('.app-edit').click
  handle_confirm_dialog do
    page.find('.app-delete-collection').click
  end
end

Given %r{^I no longer see the collection in my list$} do
  page.should_not have_css('.app-view-collection')
end

Given %r{^I edit my collection$} do
  visit_profile_for my.user
  page.find('.app-view-collection').click
  page.find('h1 .app-edit').click
  fill_in "collection-name", with: 'The newly redone collection!'
  page.find('.app-save').click
end

Given %r{^I see my edited collection$} do
  page.should have_css('.app-full-collection')
  page.should have_content('The newly redone collection!')
end
