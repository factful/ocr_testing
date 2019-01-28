=begin
  This will need to:

    - find the images in question
    - binarize them
    - segment them
    - find the location of the segmented images
    - recognize the segmented images
    - stitch together the recognized output

  Requirements:
    - where do the ocropus commands/binaries live?
    - where does the ocropus model data live?

=end

here = File.dirname(__FILE__)
require File.join(here, "utility")

module OCR
  class OCRopus < Thor
    include OCR::Utility

    desc "[file or directory of files]", ""
    def recognize(maybe_paths)
      puts "OCR #{maybe_paths} with ocropus!"
      paths = select_images(maybe_paths)
    end

    desc "binarize [file or directory of files]", ""
    def binarize(maybe_paths)
      puts "Binarize #{maybe_paths} with ocropus"
      destination_base = options[:destination] ? options[:destination] : '.'
      
      #if (dest = options[:destination])
      #  unless File.exists? dest
      #    raise ArgumentError, "Can't save files to `#{dest}` (path doesn't exist)"
      #  end
      #  unless File.directory? dest
      #    raise ArgumentError, "Can't save files to `#{dest}` (path isn't a directory)"
      #  end
      #end
      paths = select_images(maybe_paths)
      paths.each do |path|
        executable = 'ocropus-nlbin'
        # ugh, just make a directory per page.
        # identifying what kind of bash glob to try to pass in
        # here is way too much of a mess.
        basename = File.basename(path, ".*")
        destination = File.join(destination_base, basename)
        FileUtils.mkdir_p(destination)

        cmd = "#{executable} -n -o #{destination} #{path}"
        puts `#{cmd}`
      end
    end

    desc "segment [file or directory of files]", ""
    def segment(*maybe_paths)
      if maybe_paths.size > 1

      else
        puts "Splitting images in #{maybe_paths.first} with ocropus"
      end
      paths = select_images(maybe_paths)
      paths.each do |path|
        executable = 'ocropus-gpageseg'
        cmd = "#{executable} -n --minscale 5 #{path}"
        puts `#{cmd}`
      end
    end

    default_task :recognize
  end
end