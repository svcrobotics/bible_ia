# app/services/matthieu_service.rb
class MatthieuService
  FICHIER_VERSETS = Rails.root.join("config", "matthieu.yaml")

  def self.trouver_verset(message)
    data = YAML.load_file(FICHIER_VERSETS)
    versets = data["Matthieu"]
    mots_cles = extraire_mots_cles(message)

    resultats = []

    versets.each do |chapitre, versets_chap|
      versets_chap.each do |numero, texte|
        if mots_cles.any? { |mot| texte.downcase.include?(mot) }
          resultats << { reference: "Matthieu #{chapitre}, #{numero}", texte: texte }
        end
      end
    end

    resultats.sample || random
  end

  def self.random
    data = YAML.load_file(FICHIER_VERSETS)
    chapitre = data["Matthieu"].keys.sample
    verset = data["Matthieu"][chapitre].keys.sample
    {
      reference: "Matthieu #{chapitre}, #{verset}",
      texte: data["Matthieu"][chapitre][verset]
    }
  end

  def self.extraire_mots_cles(message)
    message.downcase.scan(/\b[a-zà-ÿ]{4,}\b/) - %w[alors donc parce aussi mais avec sans pour dans vers chez cela tout toute tous elles eux être avoir faire aller dire pouvoir devoir comme plus moins entre]
  end
end
