class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages or /messages.json
  def index
    @messages = Message.order(created_at: :desc)
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    mots_cles = MatthieuService.extraire_mots_cles(@message.contenu)
    flash.now[:notice] = "🔎 Mots-clés extraits : #{mots_cles.join(', ')}"

    if @message.save
      verset = MatthieuService.trouver_verset(@message.contenu)
      citation = EmmetFoxService.random

      @message.update(
        reponse: "📖 #{verset[:reference]} : « #{verset[:texte]} »\n\n💬 Emmet Fox : #{citation['texte']}"
      )

      redirect_to messages_path  # 👈 redirection classique avec rechargement complet
    else
      @messages = Message.order(created_at: :desc)
      render :index
    end
  end




  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end


  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to messages_path, status: :see_other, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:contenu)
    end

    def generer_reponse_ia(texte)
      client = OpenAI::Client.new
      prompt = <<~PROMPT
        Tu es un guide spirituel bienveillant et éclairé. Quel passage de l’Évangile (de Matthieu) correspond le mieux au message suivant : "#{texte}" ?
        Puis, donne une interprétation inspirée d'Emmet Fox à propos de ce passage.
      PROMPT

      response = client.chat(
        parameters: {
          model: "gpt-4", # ou "gpt-3.5-turbo"
          messages: [{ role: "user", content: prompt }],
          temperature: 0.7
        }
      )

      response.dig("choices", 0, "message", "content")
    rescue => e
      "⚠️ Erreur lors de l’appel à l’IA : #{e.message}"
    end

end
