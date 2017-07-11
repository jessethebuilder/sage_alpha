class ClientsController < ApplicationController
  include FarmShed
  before_action :authenticate_admin!, except: [:edit, :update]
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_client, only: [:show, :edit, :update, :destroy, :custom_mail_queue]

  def custom_mail_queue
    @mail_queue = MailQueue.new
  end

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
  end

  # GET /clients/1
  # GET /clients/1.json
  # def show
  # end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        ClientMailer.after_sign_up(@client, pw).deliver_now
        format.html { redirect_to clients_path, notice: "Client: #{@client.email} was sucessfully created." }
        # format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        # format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to clients_path, notice: "Client: #{@client.email} was sucessfully updated." }
        # format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        # format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:email, :keywords, :first_name, :last_name, :company_name, :phone, :client_number)
    end
end
