require_relative 'running'

module Spaces
  module Commands
    class Existing < ::Spaces::Commands::Running

      def identifier
        input[:identifier]
      end

      protected

      def _result
        struct.result = space.exist?(identifier)
      end

    end
  end
end
