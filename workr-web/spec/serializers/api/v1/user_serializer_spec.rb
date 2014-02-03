require 'spec_helper'
describe Api::V1::UserSerializer do
  describe '#as_json' do
    let(:article) { Fabricate(:article)  }
    let(:user) { Fabricate(:user) }
    subject { described_class.new user }
    it 'serializes the model properly' do
      subject.as_json.should == {user: {
                                 id: user.id,
                                 first_name: user.first_name,
                                 last_name: user.last_name,
                                 email: user.email,
                                 avatar_url: user.avatar.url,
                                 links: {
                                   collections: "/api/users/#{user.id}/collections",
                                   viewed_articles: "/api/users/#{user.id}/viewed_articles",
                                   interests: "/api/users/#{user.id}/interests",
                                   followers: "/api/users/#{user.id}/followers",
                                   following: "/api/users/#{user.id}/following",
                                 }
                                } }
    end
  end
end
