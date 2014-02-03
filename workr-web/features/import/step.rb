Given %r{^there is a user with a collection$} do 
  their.user = repository.user
  their.collection = repository.collection
end

Given %r{^I import an evernote export into their collection$} do 
  my.embedly_responses << embedly_response
  logger =  Rails.logger
  Evernote::Importer.import(evernote_import_data, their.collection.id, logger)
end

Given %r{^I import an evernote export with video into their collection$} do
  my.embedly_responses << embedly_video_response
  logger =  Rails.logger
  Evernote::Importer.import(evernote_import_data, their.collection.id, logger)
end

Given %r{^I should see a video article in the collection$} do 
  their.collection.articles.size.should == 1
  article = their.collection.articles.first
  article.class.should == VideoArticle
end

Given %r{^I should see a new article in the collection$} do 
  their.collection.articles.size.should == 1
  article = their.collection.articles.first
  article.user.should == their.user
  article.title.should == embedly_response[:title]
  article.description.should == embedly_response[:description]

  content_source = article.content_source
  content_source.url.should ==  "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd" 
  content_source.featured_image_url.should be_nil
  content_source.content.should == "Uncle Bob... stubbed out the content - smaller file size!"
  content_source.provider_name.should ==  "Butunclebob"
  content_source.provider_display.should ==  "butunclebob.com"
end

def evernote_import_data 
  enex_file = File.open(Rails.root.join('spec', 'fixtures', 'single_evernote.enex').to_s)
end


def embedly_video_response
HashWithIndifferentAccess.new(JSON.parse(<<-EMBEDLY
{ "provider_url": "http://www.youtube.com/", "authors": [], "provider_display": "youtube.com", "related": [ { "description": "Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test..", "title": "Why Jeff Bezos Bought The Washington Post For $250M", "url": "http://techcrunch.com/2013/08/09/headline-test-here/", "thumbnail_width": 350, "score": 0.7139381766319275, "thumbnail_height": 195, "thumbnail_url": "http://i1.wp.com/tctechcrunch2011.files.wordpress.com/2013/08/screen-shot-2013-08-09-at-4-26-06-pm.png?fit=440%2C330" }, { "description": "On-demand services offer a superior alternative to traditional QA service delivery models by providing a pay-per-use approach and enabling greater operational a", "title": "The Business Case for On-Demand Test Services", "url": "http://www.slideshare.net/cognizant/the-business-case-for-ondemand-test-services", "thumbnail_width": 768, "score": 0.6471179723739624, "thumbnail_height": 994, "thumbnail_url": "http://cdn.slidesharecdn.com/ss_thumbnails/the-business-case-for-on-demand-test-services-121107074020-phpapp01-thumbnail-4.jpg" }, { "description": "By Jamie Tolentino, , 01:00pm Perfecting your product's user experience (UX) means creating something that people truly enjoy using, be it an app, gadget or multifaceted service. Look no further than below and you'll find a list of 13 excellent UX tips from startups like Square, Path, Uber and more.", "title": "13 ways to master UX testing for your startup", "url": "http://thenextweb.com/dd/2013/08/10/13-ways-to-master-ux-testing-for-your-startup/", "thumbnail_width": 300, "score": 0.5398112535476685, "thumbnail_height": 250, "thumbnail_url": "http://cdn.thenextweb.com/wp-content/blogs.dir/1/files/2013/08/shutterstock_73936774-300x250.jpg" } ], "favicon_url": null, "keywords": [ { "score": 118, "name": "test" }, { "score": 105, "name": "code" }, { "score": 51, "name": "write" }, { "score": 50, "name": "tdd" }, { "score": 35, "name": "decoupling" }, { "score": 31, "name": "compile" }, { "score": 30, "name": "debugged" }, { "score": 28, "name": "testable" }, { "score": 26, "name": "minute" }, { "score": 25, "name": "designs" } ], "lead": null, "original_url": "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd", "media": {}, "content": "Uncle Bob... stubbed out the content - smaller file size!", "entities": [ { "count": 1, "name": "Carlos" }, { "count": 1, "name": "Dave Keith" }, { "count": 1, "name": "John Cowan" }, { "count": 1, "name": "Bill Krueger" }, { "count": 1, "name": "Keith Gregory" } ], "provider_name": "Butunclebob", "type": "html", "description": "Over the years I have come to describe Test Driven Development in terms of three simple rules. They are: You are not allowed to write any production code unless it is to make a failing unit test pass. You are not allowed to write any more of a unit test than is sufficient to fail; and compilation failures are failures.", "embeds": [], "images": [], "safe": true, "offset": null, "cache_age": 86400, "language": "English", "url": "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd", "title": "ArticleS.UncleBob.TheThreeRulesOfTdd", "published": 1129088262000 }
EMBEDLY
))
end

def embedly_response
HashWithIndifferentAccess.new(JSON.parse(<<-EMBEDLY
{ "provider_url": "http://butunclebob.com", "authors": [], "provider_display": "butunclebob.com", "related": [ { "description": "Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test..", "title": "Why Jeff Bezos Bought The Washington Post For $250M", "url": "http://techcrunch.com/2013/08/09/headline-test-here/", "thumbnail_width": 350, "score": 0.7139381766319275, "thumbnail_height": 195, "thumbnail_url": "http://i1.wp.com/tctechcrunch2011.files.wordpress.com/2013/08/screen-shot-2013-08-09-at-4-26-06-pm.png?fit=440%2C330" }, { "description": "On-demand services offer a superior alternative to traditional QA service delivery models by providing a pay-per-use approach and enabling greater operational a", "title": "The Business Case for On-Demand Test Services", "url": "http://www.slideshare.net/cognizant/the-business-case-for-ondemand-test-services", "thumbnail_width": 768, "score": 0.6471179723739624, "thumbnail_height": 994, "thumbnail_url": "http://cdn.slidesharecdn.com/ss_thumbnails/the-business-case-for-on-demand-test-services-121107074020-phpapp01-thumbnail-4.jpg" }, { "description": "By Jamie Tolentino, , 01:00pm Perfecting your product's user experience (UX) means creating something that people truly enjoy using, be it an app, gadget or multifaceted service. Look no further than below and you'll find a list of 13 excellent UX tips from startups like Square, Path, Uber and more.", "title": "13 ways to master UX testing for your startup", "url": "http://thenextweb.com/dd/2013/08/10/13-ways-to-master-ux-testing-for-your-startup/", "thumbnail_width": 300, "score": 0.5398112535476685, "thumbnail_height": 250, "thumbnail_url": "http://cdn.thenextweb.com/wp-content/blogs.dir/1/files/2013/08/shutterstock_73936774-300x250.jpg" } ], "favicon_url": null, "keywords": [ { "score": 118, "name": "test" }, { "score": 105, "name": "code" }, { "score": 51, "name": "write" }, { "score": 50, "name": "tdd" }, { "score": 35, "name": "decoupling" }, { "score": 31, "name": "compile" }, { "score": 30, "name": "debugged" }, { "score": 28, "name": "testable" }, { "score": 26, "name": "minute" }, { "score": 25, "name": "designs" } ], "lead": null, "original_url": "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd", "media": {}, "content": "Uncle Bob... stubbed out the content - smaller file size!", "entities": [ { "count": 1, "name": "Carlos" }, { "count": 1, "name": "Dave Keith" }, { "count": 1, "name": "John Cowan" }, { "count": 1, "name": "Bill Krueger" }, { "count": 1, "name": "Keith Gregory" } ], "provider_name": "Butunclebob", "type": "html", "description": "Over the years I have come to describe Test Driven Development in terms of three simple rules. They are: You are not allowed to write any production code unless it is to make a failing unit test pass. You are not allowed to write any more of a unit test than is sufficient to fail; and compilation failures are failures.", "embeds": [], "images": [], "safe": true, "offset": null, "cache_age": 86400, "language": "English", "url": "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd", "title": "ArticleS.UncleBob.TheThreeRulesOfTdd", "published": 1129088262000 }
EMBEDLY
))
end
