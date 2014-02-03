require 'spec_helper'

describe ContentSource do
  describe "associations" do
    it { should have_many :articles }
  end

  describe "validations" do
    it "requires the url to be unique" do
      ContentSource.new(url: 'http://google.com').save
      content_source = ContentSource.new(url: 'http://google.com')
      content_source.should_not be_valid
      content_source.url = 'http://apple.com'
      content_source.should be_valid
    end

    it "requires the url to be present" do
      content_source = ContentSource.new(url: '')
      content_source.should_not be_valid
      content_source.url = 'http://apple.com'
      content_source.should be_valid
    end
  end

  describe "display name" do
    it "returns a human readable title for the record" do
      content_source = ContentSource.new(url: 'http://lmgtfy.com')
      content_source.display_name.should == 'http://lmgtfy.com'
    end
  end
end
