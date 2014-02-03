
Given %r{^there is an invite in the system$} do
  my.invite = repository.invite(active: true)
end

Given %r{^some interests exist in the system$} do
  Fabricate(:interest, name: 'Foo')
  Fabricate(:interest, name: 'Bar')
  Fabricate(:interest, name: 'Baz')
end

Given %r{^I access the root page$} do
  visit "/"
end

Given %r{^I submit my invite$} do
  fill_in("invite_code", with: my.invite.code)
  submit_invite
end


Given %r{^I access the invite$} do
  view_invite(my.invite)
end

Given %r{^I register via email$} do
  page.find('.app-register-via-email').click
end

Given %r{^I should see the new user form$} do
  page.should have_css("#registrations-new")
end

Given %r{^the invite should be tied to my user account$} do
  my.invite.reload.user.should be
  my.invite.user.email.should == "ted@example.com"
end

Given %r{^the invite should be inactive$} do
  my.invite.active.should be_false
end

Given %r{^there is an inactive invite in the system$} do
  my.invite = repository.invite(active: false)
end

Given %r{^I should be redirected to the sign in page $} do
  page.should have_css("#devise-sessions-new")
end

Given %r{^there are no invites in the system$} do
  Invite.destroy_all
end

Given %r{^I access the sign up page$} do
  visit "/sign_up/no_code"
end

Given %r{^I should be redirected to the sign in page$} do
  page.should have_css("#devise-sessions-new")
end

Given %r{^I should be returned to the new user form$} do
  #page.should have_css("form#new_user")
end

Given %r{^I submit the new user form without accepting the ToS$} do
  fill_in("user_email", with: "bill@example.com")
  fill_in("user_first_name", with: "Bill")
  fill_in("user_last_name", with: "Preston")
  fill_in("user_password", with: '123password')
  fill_in("user_password_confirmation", with: '123password')
  check 'Foo'
  check 'Baz'

  submit_signup
end

Given %r{^I submit the new user form$} do
  fill_in("user_email", with: "ted@example.com")
  fill_in("user_first_name", with: "Ted")
  fill_in("user_last_name", with: "Logan")
  fill_in("user_password", with: 'password123')
  fill_in("user_password_confirmation", with: 'password123')
  #check("user_terms_of_service")
  check 'Foo'

  submit_signup
  page.should have_css("#feed-new")
end

Given %r{^I access an active invite$} do
  my.invite = repository.invite(active: true)
  view_invite(my.invite)
end

Given %r{^I access an inactive invite$} do
  my.invite = repository.invite(active: false)
  view_invite(my.invite)
end

Given %r{^I should see the feed page$} do
  page.should have_css("#feed-new")
end
