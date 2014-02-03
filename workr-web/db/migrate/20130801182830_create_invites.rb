class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :code
      t.boolean :active, default: true
      t.integer :user_id
      t.timestamps
    end
  end
end
