# app/services/emmet_fox_service.rb
require 'yaml'

class EmmetFoxService
  FICHIER_CITATIONS = Rails.root.join("config", "emmet_fox.yaml")

  def self.random
    citations = YAML.load_file(FICHIER_CITATIONS)
    citations["EmmetFox"].sample  # 👈 On accède à la liste sous la clé "EmmetFox"
  end
end
