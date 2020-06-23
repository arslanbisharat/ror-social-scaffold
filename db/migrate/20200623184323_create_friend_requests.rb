class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.references :user, foreign_key: true
      t.references :friend, foreign_key: true
      t.boolean :confirmed

      t.timestamps
    end
  end
end
