class CreateDatas < ActiveRecord::Migration[6.1]
  def change
        create_table :Datas do |t|
      t.string :data
      t.timestamps null: false
    end
  end
end
