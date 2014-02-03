class CreateArticleRatings < ActiveRecord::Migration
  def change
    create_table :article_ratings do |t|
      t.integer :article_id
      t.integer :user_id
      t.integer :rating
    end
  end
end
