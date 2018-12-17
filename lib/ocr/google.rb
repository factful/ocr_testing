# run the following to give google's library
# the credentials it needs to function:
# export GOOGLE_APPLICATION_CREDENTIALS=credentials.json

# Imports the Google Cloud client library
require "google/cloud/vision"

module OCR
  class Google
    def initialize
      # Instantiates a client
      @vision = Google::Cloud::Vision.new
    end
    
    def analyze(paths)
      # create a bucket that we're going to push results into.
      results = []
      # grab 16 images at a time into a batch (google will take up to 16 in a single batch)
      verify_paths(paths).each_slice(16) do |image_paths|
        # open up the images,
        images = image_paths.map{ |f| @vision.image(f) }
        # and send the batch to Google for OCR.
        batch = @vision.annotate do |annotator| 
          images.each do |i| 
            annotator.annotate(i, text:true)
          end
        end
        # then stick this batch of results in our bucket
        results.push *batch
      end
      # Zip the results up with the paths (they should both be in the same order)
      @annotations = Hash[paths.zip(results)]
    end

    def write_results
      # grab the path to the original file name, and the data extracted for it
      # then write just the text out to a file (with the same name as the image)
      # and then dump all of the data (including position information) into another file.
      @annotations.each do |path, data|
        dirname = File.dirname(path)
        basename = File.basename(path, ".*")
        File.open("#{dirname}/#{basename}.google.txt", 'w'){ |f| f.puts data.text }
        File.open("#{dirname}/#{basename}.google.json", 'w'){ |f| f.puts data.to_h.to_json }
      end
    end

    def verify_paths(paths)
      found, missing = paths.partition do |path| 
        File.exist? path
      end
      puts "Skipping missing paths: \n#{ missing.join("\n") }\n"
      found
    end
  end
end


