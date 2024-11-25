class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :token, null: false
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end

    add_index :sessions, :token, unique: true
  end
end
