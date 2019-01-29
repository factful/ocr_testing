=begin
  This will have to depend on the OCRopus scripts.
=end

require File.join File.dirname(__FILE__), "ocropus"

module OCR
  class Calamari < OCRopus

    # This app assumes you have virtualenv installed
    # and that there's a python 2.7 virtualenv in ROOT/venv/ocropus
    # which has ocropus and it's dependencies installed into it,
    # as well as a python 3.x virtualenv in ROOT/venv/calamari
    # which has calamari and it's dependencies installed into it.
    VENV_DEFAULT = File.join(File.dirname(__FILE__), "..", "..", "venv", "calamari", "bin", "activate")

    def recognize_lines(*maybe_paths)
      paths = select_images(maybe_paths)
      model_path = File.join(File.dirname(__FILE__), "..", "..", "..", "calamari", "models", "antiqua_modern", "4.ckpt")

      #processor_count = 4
      #executable = "ocropus-rpred"
      executable = "calamari-predict"
      cmd = "#{executable} --checkpoint #{model_path} --files #{paths.join(' ')}"
      venv = VENV_DEFAULT
      output = `source #{venv}; #{cmd}`
      puts output
    end
  end
end