require 'net/https'
require 'json'

# For OCRestful. It works. 

class ImageReader
  def initialize(url, secret, image_path)
    @base_url = url
    @secret = secret
    @image_path = image_path
    @ocr_data = nil
  end

  def scan
    # OCRestful returns a JSON hash of links that contain the actual OCR results
    http.start do |h|
      h.request(req) do |res|
        res.read_body do |body|
          # Create some class variables to store useful information in
          @ocr_data = JSON.parse(body)
          @text_url = @ocr_data['links']['text']['href']
          puts @text_url
        end
      end
    end
  end

  def read_as_text
    # Returns OCR results as text
    text = nil

    text_request = Net::HTTP::Post.new(@text_url)
    text_request['secret'] = @secret

    http.start do |h|
      h.request(text_request) do |res|
        res.read_body do |body|
          text = body
        end
      end
    end

    text
  end

  def request_for_text_results(url)
  end

  private

  def http
    http = Net::HTTP.new(ocr_uri.host, ocr_uri.port)
    http.use_ssl = true
    http
  end

  def req
    req = Net::HTTP::Post.new(ocr_path)
    req['secret'] = @secret
    req['content-type'] = "image/#{get_file_type(@image_path)}"
    req['transfer-encoding'] = 'chunked'
    req.body_stream = File.open(@image_path)
    req
  end

  def get_file_type(path)
    path.to_s.split(".").last
  end

  def ocr_uri
    URI(@base_url + 'res')
  end

  def ocr_path
    ocr_uri.path
  end
end
