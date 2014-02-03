Given %r{^I flag the article$} do
  page.find('.app-flag-article').click
  page.find('.app-flag-option').click
end

Given %r{^an admin should be able to see the flagged article$} do
  patiently do
    Flag.count.should == 1
    Flag.first.article.should == my.article
  end
end

Given %r{^I rate the article$} do
  page.find(".app-article-#{my.article.id} .app-article-rating.interactive .app-star[data-rating='3']").click
end

Given %r{^the article has mutliple ratings$} do
  my.article.ratings.create!(rating: 2)
  my.article.ratings.create!(rating: 4)
end

Given %r{^I should see the average rating$} do
  page.execute_script("location.reload()")
  page.find(".app-article-#{my.article.id} .app-article-rating .app-star.on[data-rating='1']")
  page.find(".app-article-#{my.article.id} .app-article-rating .app-star.on[data-rating='2']")
  page.find(".app-article-#{my.article.id} .app-article-rating .app-star.on[data-rating='3']")
  page.find(".app-article-#{my.article.id} .app-article-rating .app-star.off[data-rating='4']")
  page.find(".app-article-#{my.article.id} .app-article-rating .app-star.off[data-rating='4']")
end

Given %r{^I should see my rating saved on the article$} do
  patiently do
    ratings = my.article.reload.ratings
    ratings.count.should == 1
    ratings.first.rating.should == 3
  end
end


Given %r{^I am a user viewing my collection$} do
  my.user = repository.user(password: "password", password_confirmation: "password")
  my.collection = repository.collection

  my.content_source = repository.content_source(url: "http://www.gtd.com") 
  my.article = repository.article(title: "Funding") 
  my.articles << my.article

  view_sign_in
  login(my.user.email)
  view_collection(my.collection)
end

Given %r{^I edit an article$} do
  page.find(".app-article-#{my.article.id}").hover
  page.find(".app-article-#{my.article.id} .app-edit").click
end

Given %r{^I should see the article edit page$} do
  page.find("#article-title")
  page.find("#article-description")
end


Given %r{^I change article information$} do
  fill_in 'article-title', with: "Cats"
end

Given %r{^I save the article$} do
  click_button 'Update Article'
  sleep 1
end

Given %r{^I should see the new information for ont he article$} do
  my.article.reload.title.should == "Cats"
end

Given %r{^I delete an article} do
  page.find(".app-article-#{my.article.id}").hover
  page.find(".app-article-#{my.article.id} .app-edit").click

  handle_confirm_dialog do
    page.find(".app-delete-article").click
  end

end

Given %r{^the article should be removed from the collection} do
  patiently do
    my.collection.reload.articles.should_not include(my.article)
  end
end


Given %r{^I am a user viewing an article$} do
  my.user = repository.user(password: "password", password_confirmation: "password")
  my.collection = repository.collection

  my.content_source = repository.content_source(url: "http://www.gtd.com") 
  my.article = repository.article(title: "Funding") 

  view_sign_in
  login(my.user.email)
  view_collection(my.collection)
  view_article(my.article)
end

When %r{^I close the modal$} do
  page.find("#modal-close").click
end

Then %r{^I should see the article in my recents list$} do
  page.should have_css(".app-viewed-articles .app-article-#{my.article.id}")
end
