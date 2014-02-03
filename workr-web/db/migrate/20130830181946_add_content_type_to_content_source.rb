class AddContentTypeToContentSource < ActiveRecord::Migration
  def change
    add_column :content_sources, :content_type, :string
  end
end
