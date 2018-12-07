#! /usr/bin/env ruby

# Tesseract makes things easy.
# Just say `tesseract [image to ocr'd] [destination that it'll suffix with .txt]`
def ocr(target, destination)
  cmd = "tesseract #{target} #{destination}.tesseract"
  `#{cmd}`
end

# In order to OCR a PDF, it must first be turned into images.
# mutool makes that pretty easy, and we're just going to default to
# exporting PNGs at 300 dpi.
def convert(target, destination)
  resolution = true ? "-O resolution=300" : ""
  cmd = "mutool convert #{resolution} -F png -o #{destination} #{target}"
  `#{cmd}`
end

require 'fileutils'

# Get a path to be OCR'd and check if it exists.
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

# Then OCR all the things in the queue.
ocr_queue.each_with_index do |path, index|
  puts "OCRing page #{index+1} of #{ocr_queue.size}"
  ocr(path, "#{File.dirname(path)}/#{File.basename(path, ".*")}")
end
