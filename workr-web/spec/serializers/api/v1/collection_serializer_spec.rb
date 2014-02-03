require 'spec_helper'
describe Api::V1::CollectionSerializer do
  describe '#as_json' do

    subject { described_class.new collection }
    let!(:collection) { Fabricate(:collection) }

    before do
      content_source = Fabricate(:content_source, featured_image_url: 'http://image.com/foo.bar')
      article = Fabricate(:article, content_source: content_source)
      collection.articles << article
      collection.save
    end

    it 'serializes the model properly as not editable' do
      user = Fabricate(:user)
      subject.stub(:current_user) { user }
      subject.as_json.should == {collection: {
                                 id: collection.id,
                                 name: collection.name,
                                 description: collection.description,
                                 user: collection.user_id,
                                 teaser_image: 'http://image.com/foo.bar',
                                 article_count: collection.articles.count,
                                 is_editable: false,
                                 links: {
                                   articles: "/api/collections/#{collection.id}/articles"
                                 }
                                } }
    end

    it 'serializes the model properly as editable' do
      subject.stub(:current_user) { collection.user }
      subject.as_json.should == {collection: {
                                 id: collection.id,
                                 name: collection.name,
                                 description: collection.description,
                                 user: collection.user_id,
                                 teaser_image: 'http://image.com/foo.bar',
                                 article_count: collection.articles.count,
                                 is_editable: true,
                                 links: {
                                   articles: "/api/collections/#{collection.id}/articles"
                                 }
                                } }
    end
  end
end
