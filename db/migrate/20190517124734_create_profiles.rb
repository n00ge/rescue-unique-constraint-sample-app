class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.references :user
      t.string :street
      t.string :unit
      t.string :zip

      t.timestamps
    end
  end
end
