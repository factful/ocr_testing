#! /usr/bin/env ruby

## Eventually this will be a single unified access point for all the things.
## Split PDFs into individual page images, pre-process them, OCR them. All the
## things. 


require 'fileutils'
require 'fastimage'
require 'thor'
require 'rest-client'

HERE = File.dirname(__FILE__)
require File.join(HERE, "ocr", "utility")
require File.join(HERE, "ocr", "ocropus")
require File.join(HERE, "ocr", "calamari")

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
  class OCR < Thor
    include Utility

    desc "rasterize [pdf]", "turn a PDF into a directory of images (pngs by default)"
    option :output, aliases: "o"
    option :resolution, aliases: "r"
    def rasterize(pdf)
      resolution = options[:resolution] ? "-O resolution=#{options[:resolution].to_i}" : ""
      filetype = "png"
      cmd = "mutool convert #{resolution} -F #{filetype} -o #{destination} #{target}"
      `#{cmd}`
    end

    desc "google path/to/credentials [file or directory of files]", "OCR images with Google"
    def google(credentials, maybe_paths)
      ENV["GOOGLE_APPLICATION_CREDENTIALS"]=credentials
      require "google/cloud/vision"
      require File.join(HERE, 'ocr', 'google')
      puts "OCR images with Google!"
      paths = select_images(maybe_paths)
      google = Google.new
      google.analyze(paths)
      google.write_results
    end

    desc "azure path/to/credentials [file or directory of files]", "OCR images with Azure!"
    def azure(credentials, maybe_paths)
      require File.join(HERE, 'ocr', 'azure')
      paths = select_images(maybe_paths)
      puts "OCR with Azure!"
      azure = Azure.new(credentials)
      azure.analyze(paths)
      azure.write_results
    end

    desc "tesseract [file or directory of files]", "OCR images with Tesseract!"
    def tesseract(maybe_paths)
      require File.join(HERE, "ocr", "tesseract")
      puts "OCRing `#{maybe_paths}` with Tesseract!"
      paths = select_images(maybe_paths)
      Tesseract.analyze(paths)
    end

    # see ocr/ocropus.rb
    desc "ocropus [file or directory of files]", "OCR images with OCRopus!"
    subcommand "ocropus", OCRopus

    desc "calamari [file or directory of files]", "OCR images with Calamari"
    subcommand "calamari", Calamari

    desc "abbyy [file or directory of files]", "OCR images with Abbyy Cloud"
    def abbyy(maybe_paths, credentials)
      
    end
  end
end

OCR::OCR.start(ARGV)

=begin

ocr.rb abbyy             path_to_files (options: output, credentials)
ocr.rb acrobat           path_to_files # this one makes less sense
ocr.rb aws               path_to_files (options: output, credentials)
ocr.rb azure             path_to_files (options: output, credentials)
ocr.rb calamari          path_to_files (options: output, credentials)
ocr.rb google            path_to_files (options: output, credentials)
ocr.rb ocropus           path_to_files (options: output, model)
ocr.rb ocropus binarize  path_to_files (options: ????)
ocr.rb ocropus segment   path_to_files (options: ????)
ocr.rb ocropus recognize path_to_files (options: ????)
ocr.rb tesseract         path_to_files (options: output, model, hocr, export to pdf)
ocr.rb rasterize         path_to_files (options: output, resolution)

=end
