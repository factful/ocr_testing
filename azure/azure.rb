#! /usr/bin/env ruby

# See Azure API documentation:
# https://westus.dev.cognitive.microsoft.com/docs/services/5adf991815e1060e6355ad44/operations/56f91f2e778daf14a499e1fa
#
# API limitations:
# For images uploaded directly to the API images must be:
#  * In a supported image format: JPEG, PNG, GIF, BMP.
#  * Image file size must be less than 4MB.
#  * Image dimensions must be at least 50 x 50.

require 'rest-client'
require 'json'

def ocr(path)
  region = "eastus"
  url = "https://#{region}.api.cognitive.microsoft.com/vision/v2.0/ocr"
  payload = {
    data: File.open(path, 'rb'),
    language: 'unk',
    detectOrientation: 'true'
  }
  headers = {
    'Ocp-Apim-Subscription-Key': ENV['AZURE_KEY'],
    'Content-Type': 'application/json'
  }
  puts "OCRing #{path}"
  response = RestClient.post(url, payload, headers)
  data = JSON.parse(response.body)

  dirname = File.dirname(path)
  basename = File.basename(path, ".*")
  #File.open("#{dirname}/#{basename}.azure.txt", 'w'){ |f| f.puts data.text }
  File.open("#{dirname}/#{basename}.azure.json", 'w'){ |f| f.puts response.body }
end

arg_path = ARGV.first
File.directory?(arg_path)
paths = Dir.glob(File.join arg_path, '*.{png,jpg}')

puts "Annotating #{paths.count} images..."

wait_time = (paths.size > 20) ? 3 : 0

paths.each do |path|
  ocr(path)
  if wait_time > 0
    puts  "sleeping for #{wait_time} seconds"
    sleep wait_time
  end
end
