class ClientKeywordMatchesController < ApplicationController
  before_action :authenticate_admin!

  def create
    @client_keyword_match = ClientKeywordMatch.new(client_keyword_match_params)
    @client = Client.find(client_keyword_match_params[:client_id])
    @client_keyword_match.client = @client
    @mail_image = MailImage.find(client_keyword_match_params[:mail_image_id])
    @client_keyword_match.mail_image = @mail_image
    @mail_queue = @mail_image.mail_queue

    @client_keyword_match.client.mail_images << @client_keyword_match.mail_image

    respond_to do |format|
      if(@client_keyword_match.save!)
        format.js
        format.html{ redirect_to mail_queue_path(@mail_queue ) }
      end
    end
  end

private

  def client_keyword_match_params
    params.require(:client_keyword_match).permit(:client_id, :mail_image_id, :keyword)
  end
end
