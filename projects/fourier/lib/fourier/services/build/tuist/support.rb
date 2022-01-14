# frozen_string_literal: true

module Fourier
  module Services
    module Build
      module Tuist
        class Support < Base
          def self.run(from_source: false)
            Utilities::System.tuist("build", "TuistSupport", from_source: from_source)
          end
        end
      end
    end
  end
end
