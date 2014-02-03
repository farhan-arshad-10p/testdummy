class RenameArticleRatingsToRatings < ActiveRecord::Migration
  def change
    rename_table :article_ratings, :ratings
  end
end
