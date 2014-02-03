class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.text :content
      t.text :url
      t.text :media_url
      t.text :featured_image_url
      t.text :raw_article
      t.string :provider_name
      t.string :provider_display
      t.string :provider_url
      t.integer :view_count, default: 0
      t.timestamps
    end
  end
end
