require 'spec_helper'

describe PageExtractor do
  subject { PageExtractor }

  describe ".extract" do
    let(:api) { double }
    let(:url) { "http://www.google.com/" }

    it "should extract the url from the embedly api" do
      Embedly::API.stub(:new) { api } 
      api.should_receive(:extract).with(url: url) { [:the_response] } 
      subject.extract(url).should == :the_response
    end
  end
end
