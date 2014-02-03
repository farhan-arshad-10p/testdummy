require 'spec_helper'

describe Clipper::Parser do
  subject { Clipper::Parser }

  let(:evernote_data) { %q(
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export3.dtd">
<en-export export-date="20130725T201433Z" application="Evernote" version="Evernote Mac 5.2.0 (401495)">
  <note>
    <tag>development</tag><tag>coding</tag>
    <note-attributes>
      <source-url>http://www.atomicobject.com</source-url>
    </note-attributes>
  </note>
  <note>
    <note-attributes>
      <source-url>http://www.google.com</source-url>
    </note-attributes>
  </note>
</en-export>
)}

  describe ".parse_evernote" do
    it "returns an array of source urls and tags" do
      parsed_data = subject.parse_evernote(evernote_data)
      parsed_data.should == [{
        url: "http://www.atomicobject.com", 
        tags: ["development", "coding"]
      }, 

      {
        url: "http://www.google.com", 
        tags: []
      }]
    end

    it "returns an empty array if the data is empty" do
      parsed_data = subject.parse_evernote("")
      parsed_data.should == []
    end
  end

  describe ".parse_embedly" do
    let(:description)   { "So this so rad." }
    let(:image_url)     { "http://image_url" }
    let(:embed_url)     { "<iframe url='yeah' />" }
    let(:url)           { "http://someurl.com" }
    let(:title)         { "AngularJS 1.2 and Beyond" }
    let(:provider_url)  { "http://www.techcrucher.com/" }
    let(:provider_name)  { "Tech Cruncher" }
    let(:provider_display)  { "www.techcruncher.com" }
    let(:media) { {} }
    let(:content) { "Lots of stuff" }
    let(:images) { [] }


    let(:data) {
      {
        type: type,
        provider_name: provider_name,
        provider_url: provider_url, 
        provider_display: provider_display, 
        original_url: "http://www.youtube.com/watch?v=W13qDdJDHp8",
        media: media, 
        description: description,
        images: images,
        url: url,
        title: title,
        content: content
      }
    }

     describe "with an HTML type" do
      let(:type) { "html" }

      it "sets the type" do
        parsed = subject.parse_embedly(data)
        parsed[:content_type].should == "html"
      end

      it "sets the url" do
        parsed = subject.parse_embedly(data)
        parsed[:url].should == url
      end

      it "sets the title" do
        parsed = subject.parse_embedly(data)
        parsed[:title].should == title
      end

      it "sets the description" do
        parsed = subject.parse_embedly(data)
        parsed[:description].should == description
      end

      it "sets the provider_url" do
        parsed = subject.parse_embedly(data)
        parsed[:provider_url].should == provider_url
      end

      it "sets the provider_name" do
        parsed = subject.parse_embedly(data)
        parsed[:provider_name].should == provider_name
      end

      it "sets the provider_display" do
        parsed = subject.parse_embedly(data)
        parsed[:provider_display].should == provider_display
      end

      it "sets the content" do
        parsed = subject.parse_embedly(data)
        parsed[:content].should == content
      end

      it "sets the raw article" do
        parsed = subject.parse_embedly(data)
        parsed[:raw_article].should == data.to_json
      end

      describe "with images" do
        let(:images) { [{ 
            width: 480, 
            "url" => image_url,
            height: 360, 
            caption: nil, 
            colors: [ { color: [ 241, 241, 241 ], weight: 0.461669921875 }],
            entropy: 1.77307843086, 
            size: 14841 
          },
          {
            width: 480, 
            url: "http://anotherurl.com/image.jpg",
            height: 360, 
            caption: nil, 
            colors: [ { color: [ 241, 241, 241 ], weight: 0.461669921875 }],
            entropy: 1.77307843086, 
            size: 14841 
          }, ] 
        }
        
        it "sets the featured image to the first image url" do
          parsed = subject.parse_embedly(data)
          parsed[:featured_image_url].should == image_url
        end
      end

      describe "without images" do
        let(:images) { [] }

        it "sets the featured image to "" if there is no featured image" do
          parsed = subject.parse_embedly(data)
          parsed[:featured_image].should be_nil
        end
      end
    end

    describe "from a video media provider" do
      let(:provider_url) { "http://www.youtube.com/" }
      let(:type) { "html" } 
      let(:media) { { duration: 4445, width: 500, "html" => embed_url, type: "video", height: 281 } }
    
      let(:content) { nil }

      it "should set the type to video" do
        parsed = subject.parse_embedly(data)
        parsed[:content_type].should == "video"
      end

      it "should have an embed_url" do
        parsed = subject.parse_embedly(data)
        parsed[:media_url].should == embed_url
      end
    end

    describe "with a nil type" do
      let(:type) { nil }
      let(:url) { "http://www.something.com/blah.doc" }

      it "should parse the type off the url" do
        parsed = subject.parse_embedly(data)
        parsed[:content_type].should == "file"
      end
    end


    describe "parse_url_type" do
      describe "with embedly types" do
        it "returns html with html" do
          embedly_types = {html: "html",
            text: "html", 
            image: "image", 
            video: "video", 
            audio: "html", 
            rss: nil, 
            xml: nil, 
            atom: nil,  
            json: nil,
            ppt: "file",  
            link: nil
          }

          embedly_types.each do |key, value|
            subject.parse_url_type("http://stuff.com/article/1",  "http://www.stuff.com/", key, "foo", "bar", nil).should == value
          end
        end
      end

      describe "with a known video url" do 
        it "should return video as the type" do
          subject.parse_url_type("http://youtu.be/sAExBTWIp3M",  "http://www.youtube.com/", nil, nil, nil, nil).should == "video"
          subject.parse_url_type("http://youtu.be/sAExBTWIp3M",  "http://www.vimeo.com/", nil, nil, nil, nil).should   == "video"
        end
      end

      describe "with no embedly type" do
        it "parses doc" do
          subject.parse_url_type("http://www.something.com/blah.doc",  "something.com", nil, nil, nil, nil).should == "file"
          subject.parse_url_type("http://www.something.com/blah.pdf",  "something.com", nil, nil, nil, nil).should == "file"
          subject.parse_url_type("http://www.something.com/blah.docx", "something.com", nil, nil, nil, nil).should == "file"
          subject.parse_url_type("http://www.something.com/blah.ppt",  "something.com", nil, nil, nil, nil).should == "file"
          subject.parse_url_type("http://www.something.com/blah.pptx", "something.com", nil, nil, nil, nil).should == "file"
        end

        it "returns nil if it's an unknown type" do
          subject.parse_url_type("http://www.something.com/", "something.com", nil, nil, nil, nil).should be_nil
          subject.parse_url_type("http://www.something.com/blah.foo", "something.com", nil, nil, nil, nil).should == nil 
        end
      end

      describe "with no content" do
        it "returns the image when matched as HTML but has no content and a featured image and no media" do
          subject.parse_url_type("http://stuff.com/article/1",  "http://www.stuff.com/", "html", nil, "bar", "").should == "image"
        end

        it "returns the image when matched as HTML but has no content and a featured image and has media" do
          subject.parse_url_type("http://stuff.com/article/1",  "http://www.stuff.com/", "html", nil, "bar", "media").should == "html"
        end
      end
    end
  end
end

