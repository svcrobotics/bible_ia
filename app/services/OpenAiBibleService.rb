# app/services/open_ai_bible_service.rb
class OpenAiBibleService
  COUT_PAR_1000_TOKENS = {
    "gpt-4" => 0.03 # coût estimé pour la sortie en dollars
  }

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
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7,
        max_tokens: 300
      }
    )

    texte = response.dig("choices", 0, "message", "content")&.strip || ""

    {
      evangile: texte[/\[EVANGILE\](.*?)\[REPONSE\]/m, 1]&.strip || "📖 Aucun verset trouvé.",
      inspire:  texte[/\[REPONSE\](.*?)\[EMMET\]/m, 1]&.strip || "✨ Réponse manquante.",
      fox:      texte[/\[EMMET\](.*)/m, 1]&.strip || "🕊️ Méditation manquante.",
      tokens:   response.dig("usage", "total_tokens") || 0,
      cout:     ((response.dig("usage", "total_tokens").to_i * COUT_PAR_1000_TOKENS["gpt-4"]) / 1000.0).round(4)
    }

  rescue => e
    {
      evangile: "",
      inspire: "",
      fox: "⚠️ Erreur IA : #{e.message}",
      tokens: 0,
      cout: 0
    }
  end
end
