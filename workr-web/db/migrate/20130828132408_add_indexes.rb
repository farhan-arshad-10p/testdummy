class AddIndexes < ActiveRecord::Migration
  def change
    add_index :articles, :user_id, name: 'index_articles_user_id'
    add_index :articles, :content_source_id, name: 'index_articles_content_source_id'
    add_index :collections, :user_id, name: 'index_collections_user_id'
    add_index :invites, :user_id, name: 'index_invites_user_id'
  end
end
