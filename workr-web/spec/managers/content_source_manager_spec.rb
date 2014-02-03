require 'spec_helper'

describe ContentSourceManager do
  subject { ContentSourceManager }


  describe "new_content_course" do
    let(:args) { {description: "this is the description"} }

    it "takes create a new content source with the args given" do
      content_source = subject.new_content_source(args) 
      content_source.description.should == "this is the description"
    end

    it "returns a unsaved model" do
      content_source = subject.new_content_source(args) 
      content_source.should be_new_record
    end
  end
end
