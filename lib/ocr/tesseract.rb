# A lot of people use tesseract.  As a consequence
# There are a number of libraries which folks have
# written for Ruby (and really almost any other
# programming language).
#
# Here are a few:
# - https://github.com/meh/ruby-tesseract-ocr
# - https://github.com/documentcloud/docsplit
# - 
# 
#
=begin



=end

module OCR
  class Tesseract
    def self.analyze(paths, options={})
      paths.each_with_index do |path, index|
        puts "OCRing page #{index+1} of #{paths.size} with tesseract"
        destination_base = if options[:destination].nil? or options[:destination].empty?
          File.join(File.dirname(path),File.basename(path,".*"))
        else
          options[:destination]
        end
        
        cmd = "tesseract #{path} #{destination_base}.tesseract"
        `#{cmd}`
      end
    end
  end
end