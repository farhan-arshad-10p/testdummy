class AddMediaUrlToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :media_url, :text
  end
end
