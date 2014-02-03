Given %r{^I am not logged in$} do
  email = 'linus@torvalds.com'
  password = 'password'
  my.user = repository.user(email: email, password: password, password_confirmation: password)
  my.collection = repository.collection
end

Given %r{^I should be on the login page$} do
   current_path.should == '/users/sign_in'
end

Given %r{^I signin$} do
  fill_in 'user_email', with: my.user.email
  fill_in 'user_password', with: "password"
  click_button 'Sign in'
end

Given %r{^there are articles in the system$} do
  5.times { their.articles << Fabricate(:article) }
  their.article = their.articles.first
  their.article.title = 'kittens eat apples'
  their.article.save
end

Given %r{^I view an article$} do
  visit "/articles/#{their.article.id}"
end

Given %r{^I can save the viewed article to one of my collections$} do
  page.first(".app-save-article").click

  current_path.should =~ /\/content_sources\/[0-9]+\/articles\/new/

  select my.collection.name, from: "article-collection"
  click_button 'Clip Article'

  patiently do
    my.user.articles.reload.size.should == 1
  end
  page.should have_css(".app-article", text: their.article.content_source.title)
end

Given %r{^I should be on the clip page$} do
  current_path.should =~ /\/content_sources\/[0-9]+\/articles\/new/
end

Given %r{^I am logged in and have some collections$} do
  email = 'linus@torvalds.com'
  password = 'ilovenvidia'
  my.user = repository.user(email: email, password: password, password_confirmation: password)
  my.collection = repository.collection

  visit '/users/sign_in'
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  click_button 'Sign in'
end

Given %r{^I open the clipper$} do
  page.find('.app-clip').click
end


Given %r{^I fill in the content source and submit$} do
  url = "http://www.cats.com"
  my.content_source = repository.content_source(url: url)

  fill_in 'content-source-url', with: url
  click_button 'Clip'
end

Given %r{^I fill in the article information and submit$} do
  fill_in 'article-title', with: "Cats"
  fill_in 'article-description', with: "Cats and a description of them."
  fill_in 'article-tags', with: "cats,kittens"

  select my.collection.name, from: "article-collection"
  click_button 'Clip Article'
end


Given %r{^I see the success message and confirm$} do
  page.should have_css(".app-article", text: "Cats")

  my.user.articles.size.should == 1
  article = my.user.articles.first
  article.title.should == "Cats"
  article.description.should == "Cats and a description of them."
  article.tags.map(&:name).should include("cats")
  article.tags.map(&:name).should include("kittens")
end

Given %r{^there is another user with collections and articles$} do
  email = 'jane@torvalds.com'
  password = 'ilovenvidia'

  their.content_source = repository.content_source(context: their, url: "http://www.gtd.com") 
  their.user = repository.user(context: their, email: email, password: password, password_confirmation: password)
  their.collection = repository.collection(context: their)
  their.article = repository.article(context: their)
end

Given %r{^I clip another users article$} do
  view_collection(their.collection)
  sleep 5

  page.find(".app-article-#{their.article.id}").hover
  page.find(".app-article-#{their.article.id} .app-clip").click

  fill_in 'article-title', with: "Cats"
  fill_in 'article-description', with: "Cats and a description of them."
  fill_in 'article-tags', with: "cats,kittens"

  select my.collection.name, from: "article-collection"
  click_button 'Clip Article'
end

Given %r{^I should see it in my collection$} do
  page.should have_css(".app-article", text: "Cats")
  my.collection.reload.articles.size.should == 1
end

Given %r{^I clip a url$} do
  my.content_source = repository.content_source(context: their, url: "http://www.gtd.com") 
  visit '/clip?url=http://www.gtd.com'
end

Given %r{^I should see the article create page for that content source$} do
  current_path.should == "/content_sources/#{my.content_source.id}/articles/new"
end

Given %r{^I create a new collection and finish clipping the article$} do
  fill_in 'new-collection-name', with: "New Things"
  click_button 'Create Collection'

  fill_in 'article-title', with: "Cats"
  fill_in 'article-description', with: "Cats and a description of them."
  fill_in 'article-tags', with: "cats,kittens"
  click_button 'Clip Article'
end

Given %r{^I should see the new collection with the new article clip$} do
  page.should have_css(".app-clipped-collection", text: "New Things")
end

Given %r{^I upload a template$} do
  page.find('.app-clip').click
  path = File.join(::Rails.root, "features/fixtures/test_file.pdf") 
  attach_file("content_source[file]", path)
end

Given %r{^I should see the article create page for the uploaded file$} do 
  patiently do
    content_source = ContentSource.last
    current_url.should include("/content_sources/#{content_source.id}/articles/new")
  end
end
