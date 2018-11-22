#export GOOGLE_APPLICATION_CREDENTIALS=credentials.json

# Imports the Google Cloud client library
require "google/cloud/vision"

# Your Google Cloud Platform project ID
project_id = "ocr-test-223217"

# Instantiates a client
vision = Google::Cloud::Vision.new project: project_id

# The name of the image file to annotate
arg_path = ARGV.first

File.directory?(arg_path)
paths = Dir.glob(File.join arg_path, '*.{png,jpg}')

puts "Annotating #{paths.count} images..."

annotations = []
paths.each_slice(16) do |image_paths|
  images = image_paths.map{ |f| vision.image(f) }
  results = vision.annotate do |annotator| 
    images.each do |i| 
      annotator.annotate(i, text:true)
    end
  end
  annotations.push *results
end

annotation_map = Hash[paths.zip(annotations)]

annotation_map.each do |path, data|
  dirname = File.dirname(path)
  basename = File.basename(path, ".*")
  File.open("#{dirname}/#{basename}.google.txt", 'w'){ |f| f.puts data.text }
  File.open("#{dirname}/#{basename}.google.json", 'w'){ |f| f.puts data.to_h.to_json }
end

