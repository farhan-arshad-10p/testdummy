class AddProviderNameToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :provider_name, :string
  end
end
