class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :login_name
      t.string :password
      t.string :email

      t.timestamps
    end
  end
end
