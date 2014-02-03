Given %r{^There are other users in the system$} do
  their.user = repository.user()
end

Given %r{^I am following another user$} do
  their.user = repository.user()
  my.user.following << their.user
  my.user.save
end

Given %r{^I follow another user$} do
  visit_profile_for their.user
  page.find('.app-follow-user').click
end

Given %r{^I unfollow another user$} do
  visit_profile_for their.user
  page.find('.app-unfollow-user').click
end

Given %r{^I unfollow a user from my following page$} do
  page.find('.app-unfollow-user').click
end

Given %r{^I should see them as a followed user$} do
  page.find('.app-following-count', text: '1')
  page.should have_content(their.user.full_name)
end

Given %r{^I should not see them as a followed user$} do
  page.find('.app-following-count', text: '0')
  page.should_not have_content(their.user.full_name)
end
