module Arenas
  module Commands
    class Saving < ::Spaces::Commands::Saving

      def model
        @model ||= super.associated
      end

      def space_name
        super || :arenas
      end

    end
  end
end
