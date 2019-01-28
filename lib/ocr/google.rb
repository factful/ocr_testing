# run the following to give google's library
# the credentials it needs to function:
# export GOOGLE_APPLICATION_CREDENTIALS=credentials.json

# Imports the Google Cloud client library
require "google/cloud/vision"

module OCR
  class Google
    def initialize
      # Instantiates a client
      @annotator = ::Google::Cloud::Vision::ImageAnnotator.new
    end
    
    def analyze(paths)
      responses = paths.map do |path|
        response = @annotator.text_detection( image: path )
        [path, response.responses]
      end
      @annotations = Hash[responses]
    end

    def write_results
      # grab the path to the original file name, and the data extracted for it
      # then write just the text out to a file (with the same name as the image)
      # and then dump all of the data (including position information) into another file.
      @annotations.each do |path, data| 
        dirname = File.dirname(path)
        basename = File.basename(path, ".*")
        text_path = "#{dirname}/#{basename}.google.txt"
        File.open(text_path, 'w') do |f| 
          f.puts data.map{ |a| a.full_text_annotation.text }.flatten.join("\n")
          puts "Saved text to #{text_path}"
        end
        json_path = "#{dirname}/#{basename}.google.json"
        File.open(json_path, 'w') do |f| 
          collector = data.map{ |a| a.text_annotations.map{|e| e.to_h } }
          f.puts collector.to_json
          puts "Saved json to #{json_path}"
        end
      end
    end
  end
end


