class RemoveUserIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :profiles, :user_id
  end
end
