class AddUserIdToEndorsements < ActiveRecord::Migration
  def change
    add_column :endorsements, :user_id, :integer
  end
end
