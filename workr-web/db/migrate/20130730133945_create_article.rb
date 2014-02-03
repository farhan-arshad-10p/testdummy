class CreateArticle < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :url, limit: 2083
      t.text :description
      t.text :content
      t.timestamps
    end
  end
end
