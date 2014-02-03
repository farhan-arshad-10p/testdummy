require 'spec_helper'
describe Api::V1::FeedSerializer do
  describe '#as_json' do
    let(:articles) { [double(id:99), double(id: 124)] }
    let(:feed) { {id: 'foo', articles: articles} }
    subject { described_class.new feed }
    it 'serializes the model properly' do
      subject.as_json.should == {feed: {
                                 id: 'foo',
                                 articles: [99, 124],
                                 title: 'foo'
                                } }
    end
  end
end
