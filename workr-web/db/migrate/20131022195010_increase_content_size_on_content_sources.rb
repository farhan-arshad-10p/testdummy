class IncreaseContentSizeOnContentSources < ActiveRecord::Migration
  def change
    change_column :content_sources, :content, :text, :limit => 4294967295
  end
end
