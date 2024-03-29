class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :image, null: false
      t.text :body
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
