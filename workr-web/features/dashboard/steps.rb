Given %r{^I view my feed$} do
  view_sign_in
  login(my.user.email)
  view_root
end

Given %r{^I follow another user with articles$} do
  their.user = repository.user()
  their.collection = repository.collection()
  their.content_source = repository.content_source(url: "http://www.lame.com", content: "This is a long legal document with too many big words. Very few people want to read it.")
  their.articles << repository.article(context: their, title: "Boring Content", description: "No one reads this")
  my.user.following << their.user
end

Given %r{^there are multiple articles in the system$} do
  my.collection = repository.collection unless my.collection_set?

  my.content_source = repository.content_source(url: "http://www.cats.com", content: "This is my first attempt oops, um, at an e-harmony video. Um, I'm nervous but I'm excited at the same time. So I'm just gonna start talking about what I like I love cats. I love every kind of cat.  I just wanna hug all of them but I can't Can’t hug every cat Can’t hug every cat So anyway I am a cat lover.  And I love to run.  I'm sorry I'm thinking about cats again.  Can’t hug every cat")
  my.article = repository.article(title: "Cats", description: "Lots and lots of cats.")

  my.content_source = repository.content_source(url: "http://www.gtd.com", content: "Getting things dogs, this is about dogs")
  my.articles << repository.article(title: "GTD", description: "Dogs")

  my.articles << my.article
end

Given %r{^I change to collection view$} do
  page.find('.app-collections-view').click
end

Given %r{^I should see all the collections that contain articles related to my interests$} do
  page.should have_css(".app-collection-#{my.collection.id}")
  page.should have_css(".app-view-collection", count: 1)
end

Given %r{^I should see my feed with the articles related to my interest$} do
  page.should have_css(".app-article-#{my.article.id}")
end

Given %r{^I should see articles from my followed users$} do
  page.should have_css(".app-article-#{their.articles.first.id}")
end

Given %r{^I am a user with a single interest$} do
  my.interest = repository.interest(name: "cats")
  my.user = repository.user
  my.user.interests << my.interest
end

Given(/^I am a user with mulitple interests$/) do
  my.interest = repository.interest(name: "cats")
  my.interests << my.interest
  my.interests << repository.interest(name: "dogs")
  my.user = repository.user
  my.user.interests << my.interests
end

Given(/^there are multiple articles relating to my interests$/) do
  my.collection = repository.collection unless my.collection_set?
  my.content_source = repository.content_source(url: "http://catz.com")
  my.articles << repository.article(title: "Cats")

  my.content_source = repository.content_source(url: "http://dogs.com")
  my.articles << repository.article(title: "Dogs")
end

Given(/^articles unrelated to my interests$/) do
  my.content_source = repository.content_source(url: "http://gtd.com")
  my.articles << repository.article(title: "GTD")

  my.content_source = repository.content_source(url: "http://moar.gtd.com")
  my.articles << repository.article(title: "Moar GTD")
end

Then(/^I should see my feed with the articles related to my interests$/) do
  page.should have_css(".app-article", count: 2)

  article = my.articles.detect { |a| a.title == "Cats" }
  page.should have_css(".app-article-#{article.id}")

  article = my.articles.detect { |a| a.title == "Dogs" }
  page.should have_css(".app-article-#{article.id}")
end

Then(/^I should not see articles unrelated to my interests$/) do
  article = my.articles.detect { |a| a.title == "GTD" }
  page.should_not have_css(".app-article-#{article.id}")

  article = my.articles.detect { |a| a.title == "Moar GTD" }
  page.should_not have_css(".app-article-#{article.id}")
end

