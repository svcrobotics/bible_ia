class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages or /messages.json
  def index
    @messages = Message.order(created_at: :desc)
    @message = Message.new
    @balance_api = OpenAiBibleService.balance_actuelle
  end

  
  def create
    @message = Message.new(message_params)

    if @message.save
      result = OpenAiBibleService.repondre_avec_consolation(@message.contenu)

      reponse_complete = <<~REPONSE
        📖 Parole de l'Évangile

        #{result[:evangile]}

        ✨ Réponse inspirée

        #{result[:inspire]}

        🕊️ Méditation d'Emmet Fox

        #{result[:fox]}
      REPONSE

      @message.update(
        reponse: reponse_complete.strip,
        reponse_evangile: result[:evangile],
        reponse_inspiree: result[:inspire],
        reponse_fox: result[:fox],
        tokens_utilises: result[:tokens],
        cout: result[:cout]
      )


      redirect_to messages_path, notice: "🙏 Message enregistré et réponse générée."
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

    

end
