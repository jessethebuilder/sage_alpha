class MailQueuesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mail_queue, only: [:show, :edit, :update, :destroy, :send_emails]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def send_emails
    @mail_queue.send_emails
    redirect_to mail_queue_path(@mail_queue), notice: "#{@mail_queue.sent_emails_count} email/s sent."
  end

  # GET /mail_queues
  # GET /mail_queues.json
  def index
    @mail_queues = MailQueue.all.order(created_at: :desc)
  end

  # GET /mail_queues/1
  # GET /mail_queues/1.json
  def show
  end

  # GET /mail_queues/new
  def new
    @mail_queue = MailQueue.new
  end

  # GET /mail_queues/1/edit
  def edit
  end

  # POST /mail_queues
  # POST /mail_queues.json
  def create
    @mail_queue = MailQueue.new(mail_queue_params)

    respond_to do |format|
      if @mail_queue.save
        # format.html { redirect_to @mail_queue, notice: 'Mail queue was successfully created.' }
        format.html { redirect_to mail_queues_path, notice: 'Mail queue was successfully created.' }



        # SendImageMailsJob.perform_later(MailQueue.unsent)
        # format.json { render :show, status: :created, location: @mail_queue }

        # Create and return an id. This is used by JavaScript inside ajaxImageUpload() function
        format.json { render json: @mail_queue.id }
      else
        format.html { render :new }
        # format.json { render json: @mail_queue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mail_queues/1
  # PATCH/PUT /mail_queues/1.json
  def update
    respond_to do |format|
      if @mail_queue.update(mail_queue_params)
        format.html { redirect_to @mail_queue, notice: 'Mail queue was successfully updated.' }
        format.json { render :show, status: :ok, location: @mail_queue }
      else
        format.html { render :edit }
        format.json { render json: @mail_queue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_queues/1
  # DELETE /mail_queues/1.json
  def destroy
    @mail_queue.destroy
    respond_to do |format|
      format.html { redirect_to mail_queues_url, notice: 'Mail queue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_queue
      @mail_queue = MailQueue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mail_queue_params
      # params.fetch({images: []})
      params.require(:mail_queue).permit(mail_image_attributes: [:image, :text])
    end
end
