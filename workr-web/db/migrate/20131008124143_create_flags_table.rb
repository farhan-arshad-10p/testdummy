class CreateFlagsTable < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :user_id
      t.integer :article_id
      t.string :reason
      t.boolean :open, default: true
    end

    add_index :flags, :article_id
    add_index :flags, :user_id
  end
end
