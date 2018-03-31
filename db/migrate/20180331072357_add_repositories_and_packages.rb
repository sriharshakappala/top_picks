class AddRepositoriesAndPackages < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories do |t|
      t.string :name
      t.timestamps
    end
    create_table :packages do |t|
      t.string :name
      t.integer :count
      t.timestamps
    end
  end
end
