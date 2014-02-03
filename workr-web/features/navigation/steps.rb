Given %r{^I click log out$} do
  find('.app-settings-toggle').click
  find('.app-logout').click
end

Given %r{^I am no longer logged in$} do
  page.should_not have_css('.app-logout')
end

Given %r{I should see my user in the chrome$} do
  find(".app-current-user")
end

Given %r{^There is a user with some clips$} do
  their.user = repository.user(password: "password", password_confirmation: "password")
  their.collection = repository.collection(context: their) unless their.collection_set?

  their.content_source = repository.content_source(url: "http://www.cats.com", content: "This is my first attempt oops, um, at an e-harmony video. Um, I'm nervous but I'm excited at the same time. So I'm just gonna start talking about what I like I love cats. I love every kind of cat.  I just wanna hug all of them but I can't Can’t hug every cat Can’t hug every cat So anyway I am a cat lover.  And I love to run.  I'm sorry I'm thinking about cats again.  Can’t hug every cat", context: their)
  their.article = repository.article(title: "Cats", description: "Lots and lots of cats.", context: their)
end

Given %r{^I click the user link in the article view$} do
  view_root
  search_feed("cat dog")

  patiently do
    page.should have_css(".app-article-#{their.article.id}.app-view-article")
  end

  page.first(".app-article-#{their.article.id}.app-view-article").click
  page.first(".app-clipper").click
end

Given %r{^I click the collection link in the article view$} do
  view_root
  search_feed("cat dog")

  patiently do
    page.should have_css(".app-article-#{their.article.id}.app-view-article")
  end

  page.first(".app-article-#{their.article.id}.app-view-article").click
  page.first(".app-clipped-collection").click
end

Given %r{^I see the user who clipped the article and their collections$} do
  patiently do
    page.should have_css(".app-collection-#{their.collection.id}.app-view-collection")
    page.should have_content their.collection.name
    page.should have_content "#{their.collection.articles.count} articles"
  end
end

Given %r{^I see the collection that the article has been clipped to$} do
  their.articles.each do |article|
    page.should have_css(".app-article-#{article.id}.app-view-article")
    page.should have_content their.collection.name
    page.should have_content "#{their.collection.articles.count} articles"
  end
end
