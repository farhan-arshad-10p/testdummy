class RenameUrlstoContentSources < ActiveRecord::Migration
  def change
    rename_column :articles, :url_id, :content_source_id
    rename_table :urls, :content_sources
  end
end
