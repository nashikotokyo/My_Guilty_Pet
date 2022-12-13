class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.references :subject, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :action_type, null: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
