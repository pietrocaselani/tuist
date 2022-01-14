# frozen_string_literal: true

module Fourier
  module Services
    class Focus < Base
      def self.run(targets: [], from_source: false)
        dependencies = ["dependencies", "fetch"]
        Utilities::System.tuist(*dependencies, from_source: from_source)

        cache_warm = ["cache", "warm", "--dependencies-only"]
        Utilities::System.tuist(*cache_warm, from_source: from_source)

        focus = ["focus"] + targets
        Utilities::System.tuist(*focus, from_source: from_source)
      end
    end
  end
end
