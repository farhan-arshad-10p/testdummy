class AddRawArticleToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :raw_article, :text
  end
end
