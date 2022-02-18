class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :article do |t|
      t.references :user
      t.string :article
      t.boolean :reply_check
      t.integer :reply_id
      t.timestamps null: false
    end
  end
end
