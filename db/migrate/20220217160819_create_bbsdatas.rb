class CreateBbsdatas < ActiveRecord::Migration[6.1]
  def change
    create_table :bbsdatas do |t|
      t.references :users
      t.string :article
      t.boolean :reply_check
      t.integer :reply_id
      t.timestamps null: false
    end
  end
end
