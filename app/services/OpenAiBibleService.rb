# app/services/open_ai_bible_service.rb
class OpenAiBibleService
  COUT_PAR_1000_TOKENS = {
    "gpt-4o-mini" => 0.03 # coût estimé pour la sortie en dollars
  }
  MODEL = "gpt-4o-mini"
  CONFIG_PATH = Rails.root.join("config/api_balance.yml")

  def self.repondre_avec_consolation(message)
    client = OpenAI::Client.new

    prompt = <<~PROMPT
      L'utilisateur a écrit : "#{message}"

      Réponds-lui avec une réponse spirituelle en 3 parties, toujours séparées par des balises exactes :

      [EVANGILE]
      Donne un ou deux versets provenant uniquement du Nouveau Testament (Matthieu, Marc, Luc ou Jean) — même si une citation de l'Ancien Testament semble mieux. Utilise toujours l'Évangile.

      [REPONSE]
      Un court texte de 3 à 4 lignes, pour encourager, consoler ou guider spirituellement. Style clair, positif, bienveillant.

      [EMMET]
      Une phrase dans le style d’Emmet Fox (positive, méditative, courte). Évite les répétitions. Toujours inclure cette partie.

      Réponds toujours avec ces trois balises exactement, même si une section semble difficile.
    PROMPT

    response = client.chat(
      parameters: {
        model: MODEL,
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7,
        max_tokens: 300
      }
    )

    texte = response.dig("choices", 0, "message", "content")&.strip || ""
    tokens = response.dig("usage", "total_tokens").to_i
    cout = ((tokens * COUT_PAR_1000_TOKENS[MODEL]) / 1000.0).round(4)
    maj_balance(cout)

    {
      evangile: texte[/\[EVANGILE\](.*?)\[REPONSE\]/m, 1]&.strip || "📖 Aucun verset trouvé.",
      inspire:  texte[/\[REPONSE\](.*?)\[EMMET\]/m, 1]&.strip || "✨ Réponse manquante.",
      fox:      texte[/\[EMMET\](.*)/m, 1]&.strip || "🕊️ Méditation manquante.",
      tokens: response.dig("usage", "total_tokens").to_i,
      cout:   ((response.dig("usage", "total_tokens").to_i * (COUT_PAR_1000_TOKENS[MODEL] || 0)) / 1000.0).round(4),
      balance: balance_actuelle
    }

  rescue => e
    {
      evangile: "",
      inspire: "",
      fox: "⚠️ Erreur IA : #{e.message}",
      tokens: 0,
      cout: 0,
      balance: balance_actuelle
    }
  end

  def self.balance_actuelle
    YAML.load_file(CONFIG_PATH)["openai_balance_dollars"].to_f
  end

  def self.maj_balance(cout)
    nouvelle_balance = balance_actuelle - cout
    data = { "openai_balance_dollars" => nouvelle_balance.round(4) }
    File.open(CONFIG_PATH, 'w') { |f| f.write(data.to_yaml) }
  end
end
