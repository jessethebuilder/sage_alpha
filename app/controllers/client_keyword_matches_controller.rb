class ClientKeywordMatchesController < ApplicationController
  def create
    @client_keyword_match = ClientKeywordMatch.new(client_keyword_match_params)
    @client_keyword_match.client = Client.find(client_keyword_match_params[:client_id])
    @client_keyword_match.mail_image = MailImage.find(client_keyword_match_params[:mail_image_id])

    @client_keyword_match.client.mail_images << @client_keyword_match.mail_image

    respond_to do |format|
      if(@client_keyword_match.save!)
        # Directly copied from mail_queues#show. Perehaps all of this code would be better
        # in a mail_queues_controller 
        @mail_queue = @client_keyword_match.mail_image.mail_queue
        @clients = []
        @mail_queue.mail_images.each do |mi|
          mi.clients.each do |c|
            @clients << c
          end
        end
        @clients.uniq!

        format.js
        # format.js{ redirect_to mail_queue_path(@client_keyword_match.mail_image.mail_queue) }
        # format.json {render json: {status: 'success',
        #                            id: @client_keyword_match.to_param}}
      end
    end
  end

private

  def client_keyword_match_params
    params.require(:client_keyword_match).permit(:client_id, :mail_image_id, :keyword)
  end
end
