class ChangeArticlesForUrls < ActiveRecord::Migration
  def change
    add_column :articles, :url_id, :integer
    add_column :articles, :user_id, :integer

    remove_column :articles, :content, :text
    remove_column :articles, :url, :string
    remove_column :articles, :media_url, :text
    remove_column :articles, :featured_image, :text
    remove_column :articles, :raw_article, :text
    remove_column :articles, :provider_display, :string
    remove_column :articles, :provider_name, :string
    remove_column :articles, :provider_url, :string
    remove_column :articles, :view_count, :integer
  end
end
