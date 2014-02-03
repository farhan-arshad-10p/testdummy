class AddProviderUrlToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :provider_url, :string
  end
end
