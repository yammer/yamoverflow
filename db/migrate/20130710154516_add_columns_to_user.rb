class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :mugshot_url, :string
    add_column :users, :permalink, :string
    add_column :users, :profile_url, :string
  end
end
