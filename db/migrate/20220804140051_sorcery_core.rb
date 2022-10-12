class SorceryCore < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false

      t.timestamps                null: false
    end

    add_index :users, :username, unique: true
  end
end
