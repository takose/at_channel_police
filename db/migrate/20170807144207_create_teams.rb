class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :user_token
      t.string :bot_token
      t.string :bot_id

      t.timestamps
    end
  end
end
