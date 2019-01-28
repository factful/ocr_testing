require 'rest-client'
require 'json'

here = File.dirname(__FILE__)
require File.join(here, "utility")

module OCR
  class Azure
    def initialize(maybe_credentials, options={})
      @region = options.fetch(:region, "eastus")
      credentials = if maybe_credentials.kind_of? String
        JSON.parse(File.read(maybe_credentials))
      elsif credentials.kind_of? Hash
        credentials
      else
        raise ArgumentError, "Credentials should be a path string to a credentials.json file"
      end
      @credentials = credentials
    end

    def analyze(paths)
      puts "Annotating #{paths.count} images..."

      wait_time = (paths.size > 20) ? 3 : 0
      
      responses = paths.map do |path|
        result = make_request(path)
        if wait_time > 0
          puts  "sleeping for #{wait_time} seconds"
          sleep wait_time
        end
        [path, result]
      end
      @annotations = Hash[responses]
    end

    def make_request(path)
      # We're just defaulting to the East US region.
      region = "eastus"
      # This is the REST endpoint we're going to communicate with.
      url = "https://#{region}.api.cognitive.microsoft.com/vision/v2.0/ocr"
      # Azure's other demos indicate that we can specify
      # the language or set it to "unk".  We'll also have
      # it guess at the orientation, just in case our
      # documents are oriented in a direction other than up.
      image_file = File.open(path, 'rb')
      raise ArgumentError, "Azure requires images to be smaller than 4mb." if image_file.size > 4194304
      payload = {
        data: image_file,
        language: 'unk',
        detectOrientation: 'true'
      }
      # In order to make the API actually accept a request
      # we'll need to read the credentials somewhere. This
      # script assumes it's an ENV variable.
      headers = {
        'Ocp-Apim-Subscription-Key': @credentials["key"],
        'Content-Type': 'multipart/form-data'
      }
      puts "OCRing #{path}"
      # Send the request to Azure
      begin
        response = RestClient.post(url, payload, headers)
      rescue StandardError => e
        puts e.response.body
        throw e
      end
      JSON.parse(response.body)
    end

    def write_results
      @annotations.each do |path, data|
        dirname = File.dirname(path)
        basename = File.basename(path, ".*")
        # Extract the text out of the response and write it into a file.
        text_path = "#{dirname}/#{basename}.azure.txt"
        File.open(text_path, 'w'){ |f| f.puts parse_results(data) }
        puts "Saved text to #{text_path}"
        # Write the raw JSON data out into a file.
        json_path = "#{dirname}/#{basename}.azure.json"
        File.open(json_path, 'w'){ |f| f.puts data.to_json }
        puts "Saved json to #{json_path}"
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
  end
end