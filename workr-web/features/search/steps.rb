Given %r{^I am a user viewing mulitple articles on my feed$} do
  my.user = repository.user(password: "password", password_confirmation: "password")
  my.collection = repository.collection

  my.content_source = repository.content_source(url: "http://www.gtd.com/a") 
  my.articles << repository.article(title: "GTD", type: "VideoArticle")
  my.content_source = repository.content_source(url: "http://www.gtd.com/b") 
  my.articles << repository.article(title: "GTD", type: "ImageArticle")

  my.content_source = repository.content_source(url: "http://www.funding.com", content: "I give you money")
  my.article = repository.article(title: "Funding") 
  my.articles << my.article
end

Given %r{^I search for a popular term$} do
  view_sign_in
  login(my.user.email)
  search_feed("GTD")
end

Given %r{^I should see all articles for that term$} do
  popular = my.articles - [my.article]
  page.should_not have_css(".app-article-#{my.article.id}")
  popular.each do |art|
    page.should have_css(".app-article-#{art.id}")
  end
end

Given %r{^I should be able to filter to just the video articles$} do
  page.find('.app-type-select.video').click
  patiently do
    page.should have_css(".app-article", count: 1)
  end
end

Given %r{^I should be able to filter to just the image articles$} do
  page.find('.app-type-select.image').click
  patiently do
    page.should have_css(".app-article", count: 1)
  end
end

Given %r{^I should see all the collections that contain articles related to my search$} do
  page.should have_css(".app-view-collection")
  page.should have_css(".app-collection-#{my.collection.id}")
end

Given %r{^There are many users in the system$} do
  my.users << repository.user(first_name: 'Andrew', last_name: 'Petty', email: 'ap@gmail.com')
  my.users << repository.user(first_name: 'Jeniffer', last_name: 'Andrews', email: 'ja@gmail.com')
  repository.user(first_name: 'Stacey', last_name: 'Sanders', email: 'staccyyyy@gmail.com')
end

Given %r{^I search my feed for a user name$} do
  view_sign_in
  login(my.user.email)
  search_feed("andrew")
end

Given %r{^I change to user view$} do
  page.find('.app-users-view').click
end

Given %r{^I should see all the users that match my search$} do
  my.users.each do |user|
    page.should have_css(".app-user-#{user.id}")
  end
end

Given %r{^I search my feed for a term$} do
  view_sign_in
  login(my.user.email)
  search_feed("Funding")
end

Given %r{^I should see my feed narrowed down based on my search term$} do
  page.should have_css(".app-article")
  page.should have_css(".app-article-#{my.article.id}")
end

Given %r{^I click the article search result$} do
  page.first(".app-article-#{my.article.id}.app-view-article").click
end

Given %r{^I should be able to see the individual article$} do
  patiently do
    page.should have_content(my.article.content_source.content)
  end
end

Given %r{^I should see attribution on the article$} do
  page.should have_content(my.article.content_source.provider_display)
end

Given %r{^I should see interactive attribution on the individual article$} do
  page.should have_link(my.article.content_source.provider_display)
end
