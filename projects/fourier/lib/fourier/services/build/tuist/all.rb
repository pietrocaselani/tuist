# frozen_string_literal: true

module Fourier
  module Services
    module Build
      module Tuist
        class All < Base
          def self.run(from_source: false)
            dependencies = ["dependencies", "fetch"]
            Utilities::System.tuist(*dependencies, from_source: from_source)
            Utilities::System.tuist("build", "--generate", from_source: from_source)
          end
        end
      end
    end
  end
end
