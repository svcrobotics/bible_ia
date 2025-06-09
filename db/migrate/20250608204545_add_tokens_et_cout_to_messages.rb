class AddTokensEtCoutToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :tokens_utilises, :integer
    add_column :messages, :cout, :decimal
  end
end
