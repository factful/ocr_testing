require File.join(File.dirname(__FILE__), "utility")

module OCR
  class OCRopus < Thor
    include OCR::Utility

    desc "[file or directory of files]", ""
    def process(*maybe_paths)
      puts "OCR #{maybe_paths} with ocropus!"
      # prepare images by:
      #   Cranking the contrast up on the image as high as possible
      binarized_paths = binarize(*maybe_paths)
      #   Splitting the binarized image into separate lines
      segment_paths = segment(*binarized_paths)
      #   Then take each group of lines and OCR them.
      segment_paths.each do |dirpath|
        recognize_lines(dirpath)
        compile_text(dirpath)
      end
    end

    desc "binarize [file or directory of files]", "Enhance image contrast before OCRing."
    def binarize(*maybe_paths)
      puts "Binarize #{maybe_paths} with ocropus"
      
      paths = select_images(maybe_paths)
      paths.map do |path|
        executable = 'ocropus-nlbin'

        cmd = "#{executable} -n #{path}"
        puts `#{cmd}`
        extname = File.extname(path)
        basename = File.basename(path,extname)
        dirname = File.dirname(path)
        bin_path = File.join(dirname,"#{basename}.bin.png")
        raise StandardError, "#{bin_path} is missing" unless File.exist?(bin_path)
        bin_path
      end
    end

    desc "segment [file or directory of files]", "Split images into pieces, one line per image file"
    def segment(*maybe_paths)
      paths = select_images(maybe_paths)
      paths.map do |path|
        executable = 'ocropus-gpageseg'
        cmd = "#{executable} -n --minscale 5 #{path}"
        puts `#{cmd}`
        basename = File.basename(path, ".bin.png")
        dirname = File.dirname(path)
        File.join(dirname, basename)
      end
    end

    desc "recognize [file or directory of files]", "Recognize text in line image."
    def recognize_lines(*maybe_paths)
      paths = select_images(maybe_paths)
      model_path = File.join(File.dirname(__FILE__), "..", "..", "..", "ocropy", "models", "en-default.pyrnn.gz")

      processor_count = 4
      executable = "ocropus-rpred"
      cmd = "#{executable} -n -Q #{processor_count / 2} -m #{model_path} #{paths.join(' ')}"
      output = `#{cmd}`
      puts output
    end

    def compile_text(dirpath)
      paths = Dir.glob(File.join(dirpath, "*.txt")).sort
      text_path = "#{dirpath}.txt"
      File.open(text_path, "w") do |file|
        paths.each{ |line| file.puts File.read(line) }
      end
    end

    default_task :process
  end
end