require 'spec_helper'

describe Clipper::Importer do
  subject { Clipper::Importer }

  describe '.import_content_source' do
    let(:url) { double }
    let(:file) { double }
    let(:cleaned_url) { double }
    let(:extracted_page) { double }
    let(:parsed_page) { {page: :page, url: cleaned_url} }
    let(:content_source) { double }

    describe "with a file" do
      before { ContentSource.stub(:find_by_url) { nil }}

      it "should extract the page, parse it and create a content source based on the file" do
        HostedFile.stub(:create!).with(upload: file) { double(upload: double(url: url)) } 
        ContentSourceManager.stub(:new_content_source).with({url: url, content_type: "file"}) { content_source } 
        subject.import_content_source(file: file).should == content_source
      end
    end

    describe "without an existing content source" do
      before do
        ContentSource.stub(:find_by_url) { nil }
      end

      it "should extract the page, parse it and create a content source" do
        PageExtractor.stub(:extract).with(url) { extracted_page }
        Clipper::Parser.stub(:parse_embedly).with(extracted_page) { parsed_page }
        ContentSourceManager.stub(:new_content_source).with({page: :page, url: cleaned_url}) { content_source } 
        subject.import_content_source(url: url).should == content_source
      end
    end

    describe "with an existing content source" do
      it "should return the found content source" do
        ContentSource.stub(:find_by_url).with(url) { content_source }
        subject.import_content_source(url: url).should == content_source
      end

      it "should return the found content source if the cleaned url is matched" do
        ContentSource.stub(:find_by_url).with(url) { nil }
        PageExtractor.stub(:extract).with(url) { extracted_page }
        Clipper::Parser.stub(:parse_embedly).with(extracted_page) { parsed_page }

        ContentSource.stub(:find_by_url).with(parsed_page[:url]) { content_source }
        subject.import_content_source(url: url).should == content_source
      end
    end
  end
end
