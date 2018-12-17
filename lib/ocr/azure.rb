require 'rest-client'
require 'json'

here = File.dirname(__FILE__)
require File.join(here, "utility")

module OCR
  class Azure
    def initialize(region, credentials)
      @region = region
      @credentials = credentials
    end

    def analyze(paths)
      puts "Annotating #{paths.count} images..."

      wait_time = (paths.size > 20) ? 3 : 0
      
      paths.each do |path|
        ocr(path)
        if wait_time > 0
          puts  "sleeping for #{wait_time} seconds"
          sleep wait_time
        end
      end
    end

    # Parse the plain text
    # Azure doesn't provide the text in an easily accesible way.
    # In order to get the text, you have to unpeel the position
    # data/containers to get down to the individual words.
    def parse_results(data)
      # keys: ["language", "textAngle", "orientation", "regions"]
      data["regions"].map do |region|
        region["lines"].map do |line|
          line["words"].map do |word|
            word["text"]
          end.join(" ")
        end.join("\n")
      end
    end
    
    def output_text(paths)
      paths.each do |path|
        dirname = File.dirname(path)
        basename = File.basename(path, ".*")
        data = JSON.parse(File.read(path))
        File.open("#{dirname}/#{basename}.txt", 'w'){ |f| f.puts parse_results(data) }
      end
    end
  end
end