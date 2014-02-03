class CreateViewedArticlesTable < ActiveRecord::Migration
  def change
    create_table :viewed_articles do |t|
      t.integer :user_id
      t.integer :article_id
    end

    add_index :viewed_articles, :article_id
    add_index :viewed_articles, :user_id
  end
end
