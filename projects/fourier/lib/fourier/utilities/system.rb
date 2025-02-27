# frozen_string_literal: true

require "cli/kit"

module Fourier
  module Utilities
    module System
      def self.system(*args)
        Kernel.system(*args) || exit(1)
      end

      def self.tuist(*args, **kwargs)
        @tuist = "/usr/local/bin/tuist"

        if kwargs[:from_source] || !File.exist?(@tuist)
          Dir.chdir(Constants::TUIST_DIRECTORY) do
            self.system("swift", "build")
            @tuist = ".build/debug/tuist"
          end
        end

        self.system(@tuist, *args)
      end

      def self.fixturegen(*args)
        Dir.chdir(Constants::FIXTUREGEN_DIRECTORY) do
          self.system("swift", "build")
          self.system("swift", "run", "fixturegen", *args)
        end
      end
    end
  end
end
