class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    create_table :articles_collections, id: false  do |t|
      t.integer :article_id
      t.integer :collection_id
    end

    add_index :articles_collections, :article_id
    add_index :articles_collections, :collection_id
  end
end
