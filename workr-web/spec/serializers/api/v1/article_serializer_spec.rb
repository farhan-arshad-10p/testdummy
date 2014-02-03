require 'spec_helper'
describe Api::V1::ArticleSerializer do
  describe '#as_json' do
    subject { described_class.new article, root: :article }
    let(:collection) { Fabricate(:collection) }
    let(:article) { Fabricate(:article, collections: [collection]) }
    
    describe "not owned by the current user" do
    end

    describe "owned by the current user" do
      before do
        subject.stub(:current_user) { article.user }
      end

      it 'serializes the model properly' do
        10.times do 
          Fabricate(:viewed_article, article: article)
        end
        rating = Rating.create(user: article.user, article: article, rating: 10)
        Rating.create(user: Fabricate(:user), article: article, rating: 6)

        content_source = article.content_source
        collections = article.collections
        subject.as_json.should == {article: {
                                   id: article.id,
                                   title: article.title,
                                   description: article.description,
                                   tag_list: article.tag_list,
                                   clipped_name: collections.first.user.full_name,
                                   clipped_collection: collections.first.name,
                                   collections: [collection.id],
                                   user: collections.first.user.id,
                                   collection: collections.first.id,
                                   is_file: false,
                                   is_video: false,
                                   is_image: false,
                                   is_html: true,
                                   content_source: article.content_source_id, 
                                   is_editable: true,
                                   view_count: 10,
                                   collections: [collection.id],
                                   average_rating: 8,
                                   rating: rating.id,
                                   links: { related_articles: "/api/articles/#{article.id}/related_articles" }
                                  } }
      end
    end

    describe "no ratings" do
      before do
        subject.stub(:current_user) { article.user }
      end

      it "doesn't send a rating id" do
        subject.as_json[:article][:rating].should be_nil
      end
    end

    describe "is_editable" do
      describe "owned by the current user" do
        before { subject.stub(:current_user) { article.user } }

        it 'is not editable' do
          subject.as_json[:article][:is_editable].should be_true
        end
      end

      describe "not owned by the current user" do
        before do
          user = Fabricate(:user)
          subject.stub(:current_user) { user }
        end
        
        it 'is editable' do
          subject.as_json[:article][:is_editable].should be_false
        end
      end
    end
  end
end
