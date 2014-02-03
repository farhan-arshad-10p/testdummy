Given %r{^I edit my profile$} do
  open_settings
  page.find('.app-settings').click

  fill_in "user-first-name", with: 'Troy'
  fill_in "user-last-name", with: 'Abed'
  fill_in "user-email", with: 'troy&abed@morning.com'
  page.find('.app-save').click
end

Given %r{^I should see my profile updated$} do
  patiently do
    my.user.reload
    my.user.first_name.should == "Troy"
    my.user.last_name.should == "Abed"
    my.user.email.should == 'troy&abed@morning.com'
  end
end


Given %r{^I edit my avatar$} do
  open_settings
  page.find('.app-settings').click
  path = File.join(::Rails.root, "features/fixtures/test_avatar.jpeg") 
  attach_file("user[avatar]", path)
end

Given %r{^I should see my new avatar$} do
  patiently do
    my.user.reload.avatar.url.should include("test_avatar.jpeg")
  end
end
