require_relative '../spec_helper'

describe "full schema spec" do
  include Birdbath

  it 'fits the expected structure' do
    # drop_all_tables
    # see_empty_schema
    # migrate
    see_full_schema
  end

  def see_empty_schema
    assert_schema do |s|
      # is nothing 
    end
  end
  
  def see_full_schema
    assert_schema do |s|
      s.table :flags do |t|
        t.column :id, :integer
        t.column :user_id, :integer
        t.column :article_id, :integer
        t.column :reason, :string
        t.column :open, :boolean, default: true
        t.index :user_id, name: 'index_flags_on_user_id'
        t.index :article_id, name: 'index_flags_on_article_id'
      end

      s.table :viewed_articles do |t|
        t.column :id, :integer
        t.column :user_id, :integer
        t.column :article_id, :integer
        t.index :user_id, name: 'index_viewed_articles_on_user_id'
        t.index :article_id, name: 'index_viewed_articles_on_article_id'
      end

      s.table :articles do |t|
        t.column :id, :integer
        t.column :content_source_id, :integer
        t.column :user_id, :integer
        t.column :type, :string
        t.column :title, :string
        t.column :description, :text
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.index :user_id, name: 'index_articles_user_id'
        t.index :content_source_id, name: 'index_articles_content_source_id'
      end

      s.table :content_sources do |t|
        t.column :id, :integer
        t.column :title, :string
        t.column :content_type, :string
        t.column :description, :text
        t.column :content, :text
        t.column :url, :text
        t.column :media_url, :text
        t.column :featured_image_url, :text
        t.column :raw_article, :text
        t.column :provider_name, :string
        t.column :provider_display, :string
        t.column :provider_url, :string
        t.column :view_count, :integer, default: 0
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end

      s.table :ratings do |t|
        t.column :id, :integer
        t.column :article_id, :integer
        t.column :user_id, :integer
        t.column :rating, :integer
        # t.index :article_id
        # t.index :user_id
      end

      s.table :collections do |t|
        t.column :id, :integer
        t.column :user_id, :integer
        t.column :name, :string
        t.column :description, :text
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.index :user_id, name: 'index_collections_user_id'
      end

      s.table :hosted_files do |t|
        t.column :id, :integer
        t.column :upload_file_name, :string
        t.column :upload_content_type, :string
        t.column :upload_file_size, :integer
        t.column :upload_updated_at, :datetime
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end

      s.table :invites do |t|
        t.column :id, :integer
        t.column :code, :string
        t.column :active, :boolean, default: true
        t.column :user_id, :integer
        t.column :created_at, :datetime 
        t.column :updated_at, :datetime 
        t.index :user_id, name: 'index_invites_user_id'
      end
      
      s.table :articles_collections do |t|
        t.column :article_id, :integer
        t.column :collection_id, :integer
        t.index :article_id,    name: 'index_articles_collections_on_article_id'
        t.index :collection_id, name: 'index_articles_collections_on_collection_id'
      end

      s.table :users do |t|
        t.column :id, :integer
        t.column :avatar_content_type, :string
        t.column :avatar_file_name, :string
        t.column :avatar_file_size, :integer
        t.column :avatar_updated_at, :datetime
        t.column :email, :string
        t.column :first_name, :string
        t.column :last_name, :string
        t.column :terms_of_service, :boolean, default: false
        t.column :encrypted_password, :string
        t.column :reset_password_token, :string
        t.column :reset_password_sent_at, :datetime
        t.column :remember_created_at, :datetime
        t.column :sign_in_count, :integer
        t.column :current_sign_in_at, :datetime
        t.column :last_sign_in_at, :datetime
        t.column :current_sign_in_ip, :string
        t.column :last_sign_in_ip, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :provider, :string
        t.column :uid, :string
        t.column :name, :string
        t.index :email, name: 'index_users_on_email', unique: true
        t.index :reset_password_token, name: 'index_users_on_reset_password_token', unique: true
      end

      s.table :relationships do |t|
        t.column :id, :integer
        t.column :follower_id, :integer
        t.column :followed_id, :integer
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.index :follower_id, name: 'index_relationships_on_follower_id'
        t.index :followed_id, name: 'index_relationships_on_followed_id'
        t.index [:follower_id, :followed_id], name: 'index_relationships_on_follower_id_and_followed_id', unique: true
      end

      s.table :admin_users do |t|
        t.column :id, :integer
        t.column :email, :string
        t.column :encrypted_password, :string
        t.column :reset_password_token, :string
        t.column :reset_password_sent_at, :datetime
        t.column :remember_created_at, :datetime
        t.column :sign_in_count, :integer
        t.column :current_sign_in_at, :datetime
        t.column :last_sign_in_at, :datetime
        t.column :current_sign_in_ip, :string
        t.column :last_sign_in_ip, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.index :email, name: 'index_admin_users_on_email', unique: true
        t.index :reset_password_token, name: 'index_admin_users_on_reset_password_token', unique: true
      end

      s.table :active_admin_comments do |t|
        t.column :id, :integer
        t.column :namespace, :string
        t.column :body, :text
        t.column :resource_id, :string
        t.column :resource_type, :string
        t.column :author_id, :integer
        t.column :author_type, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.index [:author_type, :author_id], name: 'index_active_admin_comments_on_author_type_and_author_id'
        t.index :namespace, name: 'index_active_admin_comments_on_namespace'
        t.index [:resource_type, :resource_id], name: 'index_active_admin_comments_on_resource_type_and_resource_id'
      end

      s.table :tags do |t|
        t.column :id, :integer
        t.column :name, :string
      end

      s.table :taggings do |t|
        t.column :id, :integer
        t.column :tag_id, :integer
        t.column :taggable_id, :integer
        t.column :taggable_type, :string

        t.column :tagger_id, :integer
        t.column :tagger_type, :string

        t.column :context, :string, :limit => 128
        t.column :created_at, :datetime 
        t.index :tag_id, name: 'index_taggings_on_tag_id'
        t.index [:taggable_id, :taggable_type, :context], name: 'index_taggings_on_taggable_id_and_taggable_type_and_context'
      end

      s.table :interests do |t|
        t.column :id, :integer
        t.column :name, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end

      s.table :interests_users do |t|
        t.column :user_id, :integer
        t.column :interest_id, :integer
        t.index :user_id,    name: 'index_interests_users_on_user_id'
        t.index :interest_id, name: 'index_interests_users_on_interest_id'
      end

      s.table :workr_settings do |t|
        t.column :id, :integer
        t.column :article_search_settings, :text
      end
    end
  end
end
