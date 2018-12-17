module OCR
  module Utility
    def select_images(glob)
      # get all the files in a directory, if user passes in a bare directory
      glob = "#{glob}/*" if File.directory?(glob)
      # get all of the paths
      paths = Dir.glob(glob)
      # and filter down to just the images
      images = paths.select do |path|
        # by checking with FastImage.
        (not File.directory?(path)) and FastImage.type(path)
      end
      puts "Selecting #{images.count} images from #{paths.count} files."
      return images
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