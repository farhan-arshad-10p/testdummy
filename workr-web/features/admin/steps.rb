Given %r{^I am on the admin panel$} do
  visit new_admin_user_session_path
  fill_in("admin_user_email", with: my.user.email)
  fill_in("admin_user_password", with: 'password')
  click_button("Login")
end

Given %r{^I add a new file upload$} do
  visit new_admin_hosted_file_path
  attach_file('hosted_file_upload', Rails.root.join('spec', 'fixtures', 'evernote-logo.png'))
  click_button("Create Hosted file")
end

Given %r{^I should see it appear in the uploaded file list$} do
  page.should have_content "Hosted file was successfully created"
  page.should have_content "UPLOAD FILE NAME"
  page.should have_content "UPLOAD FILE URL"
  page.should have_content "UPLOAD CONTENT TYPE"
  page.should have_content "UPLOAD UPDATED AT"
end

Given %r{^I have added a file upload$} do
  Fabricate(:collection, name: 'Best of')
  visit new_admin_user_session_path
  fill_in("admin_user_email", with: my.user.email)
  fill_in("admin_user_password", with: 'password')
  click_button("Login")

  visit new_admin_hosted_file_path
  attach_file('hosted_file_upload', Rails.root.join('spec', 'fixtures', 'evernote-logo.png'))
  click_button("Create Hosted file")
  
  page.should have_content "Hosted file was successfully created"
end

Given %r{^I import the upload as an article$} do
  api = double
  Embedly::API.stub(:new) { api } 
  api.should_receive(:extract) { {foo: 'bar'} }
  Clipper::Parser.stub(:parse_embedly) { {url: "http://google.com/foo.gif", content_type: "file"} } 
  click_link "Clip file to new article"
  fill_in("clip_title", with: "The New Thing")
  fill_in("clip_description", with: "There are some new things that I like")
  select("Best of", from: "clip_collection")
  fill_in("clip_tags", with: "Foo, Bar, Baz")

  click_button("Clip")
end

Given %r{^I should see the article for the file I uploaded$} do
  page.should have_content "The New Thing"
  page.should have_content "There are some new things that I like"
  page.should have_content "http://google.com"
  page.should have_content "Foo, Bar, Baz"
end
