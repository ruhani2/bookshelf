class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.references :author, foreign_key: true
      t.string :language
      t.text :description

      t.timestamps
    end
  end
end
