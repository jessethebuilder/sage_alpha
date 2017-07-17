class MailImageRequestsController < ApplicationController
  before_action :set_mail_image_request, only: [:show, :edit, :update, :destroy]

  # GET /mail_image_requests
  # GET /mail_image_requests.json
  def index
    @mail_image_requests = MailImageRequest.all.order(complete: :asc)
  end

  # GET /mail_image_requests/1
  # GET /mail_image_requests/1.json
  def show
  end

  # GET /mail_image_requests/new
  def new
    @mail_image_request = MailImageRequest.new
  end

  # GET /mail_image_requests/1/edit
  def edit
  end

  # POST /mail_image_requests
  # POST /mail_image_requests.json
  def create
    @mail_image_request = MailImageRequest.new(mail_image_request_params)

    mail_image = MailImage.find(mail_image_request_params['mail_image_id'])
    client = Client.find(mail_image_request_params['client_id'])
    @mail_image_request.mail_image = mail_image
    @mail_image_request.client = client

    respond_to do |format|
      if @mail_image_request.save!
        format.html { redirect_to @mail_image_request, notice: 'Mail image request was successfully created.' }
        format.json { render :show, status: :created, location: @mail_image_request }
        format.js
      else
        format.html { render :new }
        format.json { render json: @mail_image_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mail_image_requests/1
  # PATCH/PUT /mail_image_requests/1.json
  def update
    respond_to do |format|
      if @mail_image_request.update(mail_image_request_params)
        puts mail_image_request_params.inspect
        puts '....................'
        # format.html { redirect_to @mail_image_request, notice: 'Mail image request was successfully updated.' }
        format.json { render :show, status: :ok, location: @mail_image_request }
      else
        # format.html { render :edit }
        format.json { render json: @mail_image_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_image_requests/1
  # DELETE /mail_image_requests/1.json
  def destroy
    respond_to do |format|
      if @mail_image_request.complete?
        # Do not destroy if compelete. Instead send an error alert to user, and
        # treat as Update
        d = D.new(@mail_image_request.completed_at).datetime_with_zone
        @alert = "Your request has already been fulfilled. At #{d}."
        format.js{ render :update }
      else
        @destroyed_id = @mail_image_request.to_param
        @mail_image_request.destroy
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_image_request
      @mail_image_request = MailImageRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mail_image_request_params
      params.require(:mail_image_request).permit(:type, :complete, :tracking_id, :shipping_company,
                                                 :mail_image_id, :client_id)
    end
end
