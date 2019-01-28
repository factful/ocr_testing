module OCR
  module Utility
    def select_images(*paths)
      # possible branches:
      #   - Array w/ paths to multiple files
      #   - Array w/ path to single file
      #   - Array w/ path to directory to be globbed.
      paths = paths.flatten
      if paths.size == 1
        # if there's only one element in the paths...
        # check if the input is a directory that needs to be expanded.
        path = paths.first
        raise ArgumentError unless File.exist?(path)
        paths = Dir.glob("#{path}/*") if File.directory?(path)
      end

      # Filter down to just the images
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

module Enumerable
=begin

paths.group_by_aggregate_constraint do |group|
  group.size <= 16 and
  group.map{ |path| File.open(path).size } <= 2**10
end

=end
  def group_by_aggregate_constraint(&constraints)
    collector = []
    group = []
    self.each do |item|
      group.push(item)
      unless constraints.call(group)
        group.pop
        collector.push(group)
        group = [item]
      end
    end
    return collector
  end
end
