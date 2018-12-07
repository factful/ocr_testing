# run the following to give google's library
# the credentials it needs to function:
# export GOOGLE_APPLICATION_CREDENTIALS=credentials.json

# Imports the Google Cloud client library
require "google/cloud/vision"

# Your Google Cloud Platform project ID
project_id = "ocr-test-223217"

# Instantiates a client
vision = Google::Cloud::Vision.new project: project_id

# The name of the image file to annotate
arg_path = ARGV.first

# Get a list of all of the pngs and/or jpgs to OCR
File.directory?(arg_path)
paths = Dir.glob(File.join arg_path, '*.{png,jpg}')

puts "Annotating #{paths.count} images..."

# create a bucket that we're going to push results into.
annotations = []
# grab 16 images at a time into a batch (google will take up to 16 in a single batch)
paths.each_slice(16) do |image_paths|
  # open up the images,
  images = image_paths.map{ |f| vision.image(f) }
  # and send the batch to Google for OCR.
  results = vision.annotate do |annotator| 
    images.each do |i| 
      annotator.annotate(i, text:true)
    end
  end
  # then stick this batch of results in our bucket
  annotations.push *results
end

# Zip the results up with the paths (they should both be in the same order)
annotation_map = Hash[paths.zip(annotations)]

# grab the path to the original file name, and the data extracted for it
# then write just the text out to a file (with the same name as the image)
# and then dump all of the data (including position information) into another file.
annotation_map.each do |path, data|
  dirname = File.dirname(path)
  basename = File.basename(path, ".*")
  File.open("#{dirname}/#{basename}.google.txt", 'w'){ |f| f.puts data.text }
  File.open("#{dirname}/#{basename}.google.json", 'w'){ |f| f.puts data.to_h.to_json }
end

