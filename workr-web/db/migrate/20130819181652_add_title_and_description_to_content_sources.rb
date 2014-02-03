class AddTitleAndDescriptionToContentSources < ActiveRecord::Migration
  def change
    add_column :content_sources, :title, :string
    add_column :content_sources, :description, :text
  end
end
