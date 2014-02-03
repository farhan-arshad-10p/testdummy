class CreateWorkrSettings < ActiveRecord::Migration
  def change
    create_table :workr_settings do |t|
      t.text :article_search_settings
    end
  end
end
