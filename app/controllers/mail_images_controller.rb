# require 'open-uri'
# require 'tesseract-ocr'

class MailImagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @mail_image = MailImage.new(mail_image_params)
    mail_queue = MailQueue.find(params[:mail_queue][:id])
    mail_queue.mail_images << @mail_image

    img = URI::Data.new(@mail_image.image)

    c = img.content_type.split('/')
    # content_type should be something like "image/jpeg"
    type = c[0]
    ext = c[1]

    # Build a file path for s3
    folder = @mail_image.mail_queue.created_at.to_i.to_s
    file_name = Time.now.to_i.to_s + Faker::Lorem.word
    path = "#{folder}/#{file_name}.#{ext}"

    # S3_BUCKET is set up in aws initializer
    saved_img = S3_BUCKET.object(path)
    # Save to S3
    saved_img.put(body: img.data, acl:'public-read')

    @mail_image.image = "#{S3_BUCKET.url}/#{path}"

    tmp_path = MiniMagick::Image.open(@mail_image.image)
    ocr = RTesseract.new(tmp_path)

    @mail_image.text = ocr.to_s.strip

    @mail_image.queue_emails


    respond_to do |format|
      if @mail_image.save
        format.json do
          render json: true
        end
      else
        format.html { render :new }
        format.json { render json: @mail_image.errors, status: :unprocessable_entity }
      end
    end
  end

  def mail_image_params
    params.require(:mail_image).permit(:mail_queue_id, :text, :image)
  end
end
