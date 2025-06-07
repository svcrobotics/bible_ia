class AddReponseToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :reponse, :text
  end
end
