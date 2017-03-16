require 'assets/image_reader'

namespace :sage do
  # task :read => :environment do
  #   i = ImageReader.new(ENV['OCRESTFUL_BASE_URL'],
  #                       ENV['OCRESTFUL_API_SECRET'],
  #                       Rails.root.join('temp/2.png '))
  #   i.scan
  #   puts i.read_as_text
  # end

  task :read => :environment do
    ocr = MailReader.new
    ocr.read(Rail.root.join('temp/2.png')).strip
  end

  task :r => :read
end
