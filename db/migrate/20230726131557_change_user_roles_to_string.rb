class ChangeUserRolesToString < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :roles, :string
  end
end
