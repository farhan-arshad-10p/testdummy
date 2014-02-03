Fabricator(:article) do
  title { Faker::Company.bs }
  description { Faker::Lorem.sentences(1).first }
  collections(count: 1)
  type { "HtmlArticle" }
  content_source
  user
end

Fabricator(:video_article, from: :article) do
  type { "VideoArticle" }
end
