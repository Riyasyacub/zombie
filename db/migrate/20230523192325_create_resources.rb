class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.string :name
      t.float :quantity, default: 0.0
      t.timestamps
    end
  end
end
