class AddIndexForNameInPackageAndRepository < ActiveRecord::Migration[5.1]
  def change
    add_index :repositories, :name
    add_index :packages, :name
  end
end
