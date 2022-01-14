# frozen_string_literal: true

require "thor"

module Fourier
  module Commands
    class Focus < Base
      default_command :focus

      desc "TARGETS", "Generate Tuist's project focusing on the targets TARGETS"
      option(
        :source,
        desc: "Builds Tuist from source and uses that to focus on the targets.",
        type: :boolean,
        required: false
      )
      def focus(*targets)
        Utilities::Output.section("Focusing on targets: #{targets.inspect}")

        Services::Focus.run(targets: targets, from_source: options[:source])

        Utilities::Output.success("Focused on targets: #{targets.inspect}!")
      end
    end
  end
end
