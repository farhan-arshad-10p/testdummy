require 'spec_helper'

describe Evernote::Importer do
  subject { Evernote::Importer }
  let(:logger) { double }
  before { logger.stub(:info) }

  describe ".import" do
    it "should import a given file" do
      collection = Fabricate(:collection)
      PageExtractor.should_receive(:extract).with("http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd") { data_for("http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd") }
      PageExtractor.should_receive(:extract).with("http://guides.rubyonrails.org/testing.html") { data_for("http://guides.rubyonrails.org/testing.html") }

      enex_file = File.open(Rails.root.join('spec', 'fixtures', 'evernote', 'evernote_testing.enex').to_s)
      Evernote::Importer.import(enex_file, collection.id, logger)

      collection.reload.articles.size.should == 2

      article = collection.articles.first
      article.title.should == "ArticleS.UncleBob.TheThreeRulesOfTdd"
      article.description.should == "Over the years I have come to describe Test Driven Development in terms of three simple rules. They are: You are not allowed to write any production code unless it is to make a failing unit test pass. You are not allowed to write any more of a unit test than is sufficient to fail; and compilation failures are failures."
      article.tag_list.should =~ ['foo', 'bar', 'baz']

      content_source = article.content_source
      content_source.title.should == "ArticleS.UncleBob.TheThreeRulesOfTdd"
      content_source.description.should == "Over the years I have come to describe Test Driven Development in terms of three simple rules. They are: You are not allowed to write any production code unless it is to make a failing unit test pass. You are not allowed to write any more of a unit test than is sufficient to fail; and compilation failures are failures."
      content_source.url.should == "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd"
      content_source.content.should == "Uncle Bob... stubbed out the content - smaller file size!"
      content_source.provider_name.should == "Butunclebob"
      content_source.provider_url.should == "http://butunclebob.com"
      content_source.featured_image_url.should be_nil

      article = collection.articles.last
      article.title.should == "A Guide to Testing Rails Applications - Ruby on Rails Guides"
      article.description.should == "1 Why Write Tests for your Rails Applications? Rails makes it super easy to write your tests. It starts by producing skeleton test code while you are creating your models and controllers. By simply running your Rails tests you can ensure your code adheres to the desired functionality even after some major code refactoring."
      article.tag_list.should =~ ['abc', 'def', 'xyz']
      content_source = article.content_source
      content_source.title.should == "A Guide to Testing Rails Applications - Ruby on Rails Guides"
      content_source.description.should == "1 Why Write Tests for your Rails Applications? Rails makes it super easy to write your tests. It starts by producing skeleton test code while you are creating your models and controllers. By simply running your Rails tests you can ensure your code adheres to the desired functionality even after some major code refactoring."
      content_source.url.should == "http://guides.rubyonrails.org/testing.html"
      content_source.content.should == "Rails guide on testing"
      content_source.provider_name.should == "Rubyonrails"
      content_source.provider_url.should == "http://guides.rubyonrails.org"
      content_source.featured_image_url.should be_nil
    end
  end

  describe ".import_directory" do
    it "should import a given directory" do
      user = Fabricate(:user)

      PageExtractor.stub(:extract).with("http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd") { data_for("http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd") }
      PageExtractor.stub(:extract).with("http://guides.rubyonrails.org/testing.html") { data_for("http://guides.rubyonrails.org/testing.html") }
      PageExtractor.stub(:extract).with("http://us.playstation.com/develop/") { data_for("http://us.playstation.com/develop/") }

      Evernote::Importer.import_directory(Rails.root.join('spec', 'fixtures', 'evernote'), user.id, logger)

      user.reload.collections.map(&:name).should =~ ["Evernote Testing", "Evernote Development"]
      collection_should_contain("Evernote Testing", ["ArticleS.UncleBob.TheThreeRulesOfTdd", "A Guide to Testing Rails Applications - Ruby on Rails Guides"])
      collection_should_contain("Evernote Development", ["Developer & Publisher Support", "ArticleS.UncleBob.TheThreeRulesOfTdd"])
      Article.all.reload.size.should == 3
      ContentSource.all.reload.size.should == 3
    end

    it "should throw when the user is not valid"
  end

  def collection_should_contain(collection_name, article_names)
    Collection.where(name: collection_name).first.articles.map(&:title).should =~ article_names
  end

  def data_for(url)
    JSON.parse json_for(url), symbolize_names: true
  end

  def json_for(url)
    case url
    when "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd"
      <<-eos
{
    "provider_url": "http://butunclebob.com", 
    "authors": [], 
    "provider_display": "butunclebob.com", 
    "related": [
        {
            "description": "Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test, test, test, test, test, test, test. Test, test..", 
            "title": "Why Jeff Bezos Bought The Washington Post For $250M", 
            "url": "http://techcrunch.com/2013/08/09/headline-test-here/", 
            "thumbnail_width": 350, 
            "score": 0.7139381766319275, 
            "thumbnail_height": 195, 
            "thumbnail_url": "http://i1.wp.com/tctechcrunch2011.files.wordpress.com/2013/08/screen-shot-2013-08-09-at-4-26-06-pm.png?fit=440%2C330"
        }, 
        {
            "description": "On-demand services offer a superior alternative to traditional QA service delivery models by providing a pay-per-use approach and enabling greater operational a", 
            "title": "The Business Case for On-Demand Test Services", 
            "url": "http://www.slideshare.net/cognizant/the-business-case-for-ondemand-test-services", 
            "thumbnail_width": 768, 
            "score": 0.6471179723739624, 
            "thumbnail_height": 994, 
            "thumbnail_url": "http://cdn.slidesharecdn.com/ss_thumbnails/the-business-case-for-on-demand-test-services-121107074020-phpapp01-thumbnail-4.jpg"
        }, 
        {
            "description": "By Jamie Tolentino, , 01:00pm Perfecting your product's user experience (UX) means creating something that people truly enjoy using, be it an app, gadget or multifaceted service. Look no further than below and you'll find a list of 13 excellent UX tips from startups like Square, Path, Uber and more.", 
            "title": "13 ways to master UX testing for your startup", 
            "url": "http://thenextweb.com/dd/2013/08/10/13-ways-to-master-ux-testing-for-your-startup/", 
            "thumbnail_width": 300, 
            "score": 0.5398112535476685, 
            "thumbnail_height": 250, 
            "thumbnail_url": "http://cdn.thenextweb.com/wp-content/blogs.dir/1/files/2013/08/shutterstock_73936774-300x250.jpg"
        }
    ], 
    "favicon_url": null, 
    "keywords": [
        {
            "score": 118, 
            "name": "test"
        }, 
        {
            "score": 105, 
            "name": "code"
        }, 
        {
            "score": 51, 
            "name": "write"
        }, 
        {
            "score": 50, 
            "name": "tdd"
        }, 
        {
            "score": 35, 
            "name": "decoupling"
        }, 
        {
            "score": 31, 
            "name": "compile"
        }, 
        {
            "score": 30, 
            "name": "debugged"
        }, 
        {
            "score": 28, 
            "name": "testable"
        }, 
        {
            "score": 26, 
            "name": "minute"
        }, 
        {
            "score": 25, 
            "name": "designs"
        }
    ], 
    "lead": null, 
    "original_url": "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd", 
    "media": {}, 
    "content": "Uncle Bob... stubbed out the content - smaller file size!",
    "entities": [
        {
            "count": 1, 
            "name": "Carlos"
        }, 
        {
            "count": 1, 
            "name": "Dave Keith"
        }, 
        {
            "count": 1, 
            "name": "John Cowan"
        }, 
        {
            "count": 1, 
            "name": "Bill Krueger"
        }, 
        {
            "count": 1, 
            "name": "Keith Gregory"
        }
    ], 
    "provider_name": "Butunclebob", 
    "type": "html", 
    "description": "Over the years I have come to describe Test Driven Development in terms of three simple rules. They are: You are not allowed to write any production code unless it is to make a failing unit test pass. You are not allowed to write any more of a unit test than is sufficient to fail; and compilation failures are failures.", 
    "embeds": [], 
    "images": [], 
    "safe": true, 
    "offset": null, 
    "cache_age": 86400, 
    "language": "English", 
    "url": "http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd", 
    "title": "ArticleS.UncleBob.TheThreeRulesOfTdd", 
    "published": 1129088262000
}
      eos
    when 'http://guides.rubyonrails.org/testing.html'
      <<-eos
{
    "provider_url": "http://guides.rubyonrails.org", 
    "authors": [], 
    "provider_display": "guides.rubyonrails.org", 
    "favicon_url": "http://guides.rubyonrails.org/images/favicon.ico", 
    "keywords": [
        {
            "score": 906, 
            "name": "test"
        }, 
        {
            "score": 309, 
            "name": "fixtures"
        }, 
        {
            "score": 307, 
            "name": "assertions"
        }, 
        {
            "score": 262, 
            "name": "rails"
        }, 
        {
            "score": 176, 
            "name": "post"
        }, 
        {
            "score": 161, 
            "name": "assert_select"
        }, 
        {
            "score": 161, 
            "name": "mailers"
        }, 
        {
            "score": 145, 
            "name": "methods"
        }, 
        {
            "score": 130, 
            "name": "testcase"
        }, 
        {
            "score": 127, 
            "name": "example"
        }
    ], 
    "lead": null, 
    "original_url": "http://guides.rubyonrails.org/testing.html", 
    "media": {}, 
    "content": "Rails guide on testing",
    "entities": [
        {
            "count": 5, 
            "name": "YAML"
        }, 
        {
            "count": 3, 
            "name": "Ruby"
        }, 
        {
            "count": 2, 
            "name": "david"
        }, 
        {
            "count": 2, 
            "name": "ERB"
        }, 
        {
            "count": 1, 
            "name": "CGI"
        }, 
        {
            "count": 1, 
            "name": "Mailer"
        }, 
        {
            "count": 1, 
            "name": "Brief Note About MiniTest Ruby"
        }, 
        {
            "count": 1, 
            "name": "Integration Testing Integration"
        }, 
        {
            "count": 1, 
            "name": "Rails"
        }, 
        {
            "count": 1, 
            "name": "Rails Specific Assertions Rails"
        }, 
        {
            "count": 1, 
            "name": "David Heinemeier Hansson"
        }, 
        {
            "count": 1, 
            "name": "IntegrationTest"
        }, 
        {
            "count": 1, 
            "name": "Steve Ross Kellock"
        }, 
        {
            "count": 1, 
            "name": "Helpers Available for Integration"
        }, 
        {
            "count": 1, 
            "name": "CSS"
        }
    ], 
    "provider_name": "Rubyonrails", 
    "type": "html", 
    "description": "1 Why Write Tests for your Rails Applications? Rails makes it super easy to write your tests. It starts by producing skeleton test code while you are creating your models and controllers. By simply running your Rails tests you can ensure your code adheres to the desired functionality even after some major code refactoring.", 
    "embeds": [], 
    "images": [], 
    "safe": true, 
    "offset": null, 
    "cache_age": 86400, 
    "language": "English", 
    "url": "http://guides.rubyonrails.org/testing.html", 
    "title": "A Guide to Testing Rails Applications - Ruby on Rails Guides", 
    "published": null
}
      eos
    when "http://us.playstation.com/develop/"
      <<-eos
{
    "provider_url": "http://us.playstation.com", 
    "authors": [], 
    "provider_display": "us.playstation.com", 
    "related": [
        {
            "description": "Here's Duke Nukem 3D: Megaton Edition running on a @PlayStation Vita. That is all. cc @AbstractionGame pic.twitter.com/imJbbWtkfS", 
            "title": "Twitter / devolverdigital: Here's Duke Nukem 3D: Megaton ...", 
            "url": "https://twitter.com/devolverdigital/status/366944848948903937", 
            "thumbnail_width": 150, 
            "score": 0.5283692479133606, 
            "thumbnail_height": 150, 
            "thumbnail_url": "https://pbs.twimg.com/media/BRemZV5CQAEMZ2g.jpg:thumb"
        }
    ], 
    "favicon_url": "http://webassets.scea.com/pscomauth/groups/public/documents/webasset/psn_favicon.ico", 
    "keywords": [
        {
            "score": 17, 
            "name": "playstation"
        }, 
        {
            "score": 10, 
            "name": "companyregistration"
        }, 
        {
            "score": 10, 
            "name": "devnet"
        }, 
        {
            "score": 10, 
            "name": "selfpublish"
        }, 
        {
            "score": 9, 
            "name": "americas"
        }, 
        {
            "score": 8, 
            "name": "www"
        }, 
        {
            "score": 8, 
            "name": "please"
        }, 
        {
            "score": 8, 
            "name": "located"
        }, 
        {
            "score": 8, 
            "name": "static"
        }, 
        {
            "score": 7, 
            "name": "https"
        }
    ], 
    "lead": null, 
    "original_url": "http://us.playstation.com/develop/", 
    "media": {}, 
    "content": "Become a playstation developer",
    "entities": [
        {
            "count": 1, 
            "name": "Canada"
        }, 
        {
            "count": 1, 
            "name": "Mexico"
        }, 
        {
            "count": 1, 
            "name": "Central America"
        }, 
        {
            "count": 1, 
            "name": "US"
        }, 
        {
            "count": 1, 
            "name": "Americas"
        }, 
        {
            "count": 1, 
            "name": "South America"
        }
    ], 
    "provider_name": "Playstation", 
    "type": "html", 
    "description": "Before applying, please make sure the following requirements are met: Form a Corporate Entity Obtain an Employer Tax ID Number (see www.irs.gov) (Recommended) Static IP (Required for DevNet Access) You must be physically located in US, Mexico, Central America, South America, or Canada For companies located outside of the Americas, please see https://www.companyregistration.playstation.com Questions?", 
    "embeds": [], 
    "images": [
        {
            "width": 75, 
            "url": "http://webassets.scea.com/pscomauth/groups/public/documents/webasset/dev_share.jpg", 
            "height": 75, 
            "caption": null, 
            "colors": [
                {
                    "color": [
                        246, 
                        250, 
                        251
                    ], 
                    "weight": 0.9091796875
                }, 
                {
                    "color": [
                        0, 
                        52, 
                        140
                    ], 
                    "weight": 0.069091796875
                }, 
                {
                    "color": [
                        85, 
                        123, 
                        169
                    ], 
                    "weight": 0.021728515625
                }
            ], 
            "entropy": 1.96158444128, 
            "size": 13399
        }, 
        {
            "width": 428, 
            "url": "http://webassetsf.scea.com/pscomauth/groups/public/documents/webasset/dev-psm.png", 
            "height": 339, 
            "caption": null, 
            "colors": [
                {
                    "color": [
                        21, 
                        26, 
                        37
                    ], 
                    "weight": 0.34765625
                }, 
                {
                    "color": [
                        246, 
                        249, 
                        248
                    ], 
                    "weight": 0.282470703125
                }, 
                {
                    "color": [
                        74, 
                        68, 
                        65
                    ], 
                    "weight": 0.095947265625
                }, 
                {
                    "color": [
                        172, 
                        192, 
                        201
                    ], 
                    "weight": 0.070068359375
                }, 
                {
                    "color": [
                        87, 
                        108, 
                        127
                    ], 
                    "weight": 0.052001953125
                }
            ], 
            "entropy": 5.200565017602109, 
            "size": 202160
        }, 
        {
            "width": 329, 
            "url": "http://webassetsg.scea.com/pscomauth/groups/public/documents/webasset/dev-dust.png", 
            "height": 353, 
            "caption": null, 
            "colors": [
                {
                    "color": [
                        31, 
                        34, 
                        38
                    ], 
                    "weight": 0.29931640625
                }, 
                {
                    "color": [
                        214, 
                        219, 
                        222
                    ], 
                    "weight": 0.26123046875
                }, 
                {
                    "color": [
                        12, 
                        13, 
                        15
                    ], 
                    "weight": 0.21337890625
                }, 
                {
                    "color": [
                        71, 
                        76, 
                        85
                    ], 
                    "weight": 0.09619140625
                }, 
                {
                    "color": [
                        130, 
                        136, 
                        146
                    ], 
                    "weight": 0.0947265625
                }
            ], 
            "entropy": 4.043158722615691, 
            "size": 130484
        }, 
        {
            "width": 185, 
            "url": "http://webassetsa.scea.com/pscomauth/groups/public/documents/webasset/dev-psvita-img.png", 
            "height": 105, 
            "caption": null, 
            "colors": [
                {
                    "color": [
                        11, 
                        12, 
                        15
                    ], 
                    "weight": 0.8994140625
                }, 
                {
                    "color": [
                        193, 
                        199, 
                        206
                    ], 
                    "weight": 0.056396484375
                }, 
                {
                    "color": [
                        145, 
                        148, 
                        153
                    ], 
                    "weight": 0.023681640625
                }, 
                {
                    "color": [
                        101, 
                        104, 
                        109
                    ], 
                    "weight": 0.0205078125
                }
            ], 
            "entropy": 2.240578775741862, 
            "size": 17858
        }, 
        {
            "width": 172, 
            "url": "http://webassetsc.scea.com/pscomauth/groups/public/documents/webasset/dev-psm-img.png", 
            "height": 123, 
            "caption": null, 
            "colors": [
                {
                    "color": [
                        17, 
                        19, 
                        21
                    ], 
                    "weight": 0.89599609375
                }, 
                {
                    "color": [
                        70, 
                        60, 
                        68
                    ], 
                    "weight": 0.035400390625
                }, 
                {
                    "color": [
                        32, 
                        57, 
                        150
                    ], 
                    "weight": 0.021484375
                }, 
                {
                    "color": [
                        0, 
                        102, 
                        179
                    ], 
                    "weight": 0.011474609375
                }, 
                {
                    "color": [
                        0, 
                        165, 
                        231
                    ], 
                    "weight": 0.010009765625
                }
            ], 
            "entropy": 3.045850310129973, 
            "size": 22723
        }
    ], 
    "safe": true, 
    "offset": null, 
    "cache_age": 86400, 
    "language": "English", 
    "url": "http://us.playstation.com/develop/", 
    "title": "Developer & Publisher Support", 
    "published": null
}
      eos
    else
      "{}"
    end
  end
end
