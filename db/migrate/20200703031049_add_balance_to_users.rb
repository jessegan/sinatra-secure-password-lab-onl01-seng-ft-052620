class AddBalanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users,:balance,:float,:default => 0.0, :scale => 2
  end
end
