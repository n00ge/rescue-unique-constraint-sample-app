class UniqueIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
    add_index :profiles, :user_id, unique: true
    add_index :profiles, %w[street zip], unique: true
  end
end
