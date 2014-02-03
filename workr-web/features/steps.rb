Before('@stub_embedly') do
  #PageExtractor = double
  PageExtractor.stub(:extract) { my.embedly_responses.shift }
end

Given %r{^I am a user$} do
  my.user = repository.user(password: "password", password_confirmation: "password")
end

Given %r{^I visit my profile$} do
  visit '/settings'
  #visit_profile_for my.user
end

Given %r{^I am an admin user$} do
  my.user = repository.admin_user(password: "password", password_confirmation: "password")
end

Given %r{^I am logged in$} do
  email = 'joe@camel.com'
  password = 'smokingcamel99'
  my.user = Fabricate(:user, email: email, password: password, password_confirmation: password)

  visit '/users/sign_in'
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  click_button 'Sign in'
end
