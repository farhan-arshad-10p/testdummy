require 'spec_helper'
describe Api::V1::ViewedArticleSerializer do
  subject { described_class.new viewed_article, root: :viewed_article }
  let(:viewed_article) { Fabricate(:viewed_article) }

  describe '#as_json' do
    it 'serializes the model properly' do
     subject.as_json.should == {viewed_article: {
                                 id: viewed_article.id,
                                 user: viewed_article.user_id,
                                 article: viewed_article.article_id
                                } }
    end
  end
end
