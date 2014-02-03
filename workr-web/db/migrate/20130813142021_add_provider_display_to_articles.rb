class AddProviderDisplayToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :provider_display, :string
  end
end
