#! /usr/bin/env ruby

def ocr(target, destination)
  cmd = "tesseract #{target} #{destination}"
  `#{cmd}`
end

def convert(target, destination)
  cmd = "mutool convert -F png -o #{destination} #{target}"
  `#{cmd}`
end

require 'fileutils'

filename = ARGV.first
if filename.nil? or filename.empty?
  # puts help info & exit
  raise ArgumentError, "Please supply a file to OCR"
end
raise ArgumentError, "Can't find #{filename}" unless File.exist?(filename)
ext = File.extname(filename)
basename = File.basename(filename, ".*")
dirname = "#{basename}_pages"

ocr_queue = if ext == ".pdf"
  # if the file's a PDF, rasterize the images
  # with mupdf and then return the list of images.
  puts "Converting PDF to images..."
  FileUtils.mkdir_p(dirname)
  convert(filename, "#{dirname}/#{basename}_.png")
  Dir.glob("#{dirname}/#{basename}_*.png")
else
  # otherwise we're just using the single image.
  [filename]
end

ocr_queue.each_with_index do |path, index|
  puts "OCRing page #{index+1} of #{ocr_queue.size}"
  ocr(path, "#{File.dirname(path)}/#{File.basename(path, ".*")}")
end
