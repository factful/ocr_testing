require 'aws-sdk'

=begin
resp = client.detect_text({
  image: { # required
    bytes: "data",
    s3_object: {
      bucket: "S3Bucket",
      name: "S3ObjectName",
      version: "S3ObjectVersion",
    },
  },
})
=end

credential_path = ENV['AWS_APPLICATION_CREDENTIALS']
if credential_path.nil? or credential_path.empty?
  raise ArgumentError "Please `export AWS_APPLICATION_CREDENTIALS=[path to credentials]`"
end

shared_creds = Aws::SharedCredentials.new(path: credential_path)
Aws.config.update(credentials: shared_creds)


image_path = '/Users/ted/factful/ocr_testing/documents/historical-executive_order_9066-japanese_internment.jpg'

def analyze(image_path)
  client = Aws::Rekognition::Client.new
  result = client.detect_text({image: { bytes: File.open(image_path) }})

  #chunks = result.text_detections.select{|chunk| chunk.type == "LINE"}.sort_by do |chunk|
  #  box = chunk.geometry.bounding_box
  #  [box.top, box.left]
  #end
end
