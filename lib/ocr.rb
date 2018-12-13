#! /usr/bin/env ruby

require 'fileutils'
require 'fastimage'
require 'thor'
require 'rest-client'

=begin

# Additional Dependencies

## mutool

`brew install mupdf`

## tesseract

`brew install tesseract`

## OCRopus

lol i don't remember at all.  will have to read back through the documentation.  also need virtualenv and python 2.7

=end

module OCR
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

  class OCRopus < Thor

    desc "[file or directory of files]", ""
    def recognize(path)
      puts "OCR #{path} with ocropus!"
    end

    desc "binarize [file or directory of files]", ""
    def binarize(path)
      puts "Binarize #{path} with ocropus"
    end

    desc "segment [file or directory of files]", ""
    def segment(path)
      puts "Split images in #{path} with ocropus"
    end

    default_task :recognize
  end

  class OCR < Thor
    desc "rasterize [pdf]", "turn a PDF into images (pngs by default)"
    option :output, aliases: "o"
    option :resolution, aliases: "r"
    def rasterize(pdf)
      resolution = options[:resolution] ? "-O resolution=#{options[:resolution].to_i}" : ""
      cmd = "mutool convert #{resolution} -F png -o #{destination} #{target}"
      `#{cmd}`
    end

    desc "google [file or directory of files]", "OCR images with Google"
    option :credentials, aliases: "c"
    def google(path)
      require "google/cloud/vision"
      
      puts "OCR images with Google!"
    end

    desc "azure [file or directory of files]", "OCR with Azure!"
    option :credentials, aliases: "c"
    def azure(path)
      puts "OCR with Azure!"
    end

    desc "tesseract [file or directory of files]", "OCR with Tesseract!"
    def tesseract(path)
      puts "OCRing #{path} with Tesseract!"
    end

    desc "ocropus [file or directory of files]", "OCR with OCRopus!"
    subcommand "ocropus", OCRopus

  end
end

OCR::OCR.start(ARGV)

=begin

ocr.rb google            path_to_files (options: output, credentials)
ocr.rb azure             path_to_files (options: output, credentials)
ocr.rb tesseract         path_to_files (options: output, model, hocr, export to pdf)
ocr.rb rasterize         path_to_files (options: output, resolution)
ocr.rb ocropus           path_to_files (options: output, model)
ocr.rb ocropus binarize  path_to_files (options: ????)
ocr.rb ocropus segment   path_to_files (options: ????)
ocr.rb ocropus recognize path_to_files (options: ????)

=end
