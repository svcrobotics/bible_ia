class AddReponseFieldsToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :reponse_evangile, :text
    add_column :messages, :reponse_inspiree, :text
    add_column :messages, :reponse_fox, :text
  end
end
