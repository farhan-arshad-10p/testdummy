class Update < ActiveRecord::Migration
  def change
    change_column :content_sources, :raw_article, :text, :limit => 4294967295
  end
end
