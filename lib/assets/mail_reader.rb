# require 'tesseract-ocr'

class MailReader
  def initialize
    @ocr = Tesseract::Engine.new{ |e|
      e.language = :eng

    }
  end

  def read(path)
    @ocr.text_for(path)
  end
end
