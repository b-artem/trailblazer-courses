class CreateUserInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_invitations do |t|
      t.string :email, index: { unique: true }
      t.string :token, index: { unique: true }

      t.timestamps
    end
  end
end
