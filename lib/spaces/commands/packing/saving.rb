module Packing
  module Commands
    class Saving < ::Spaces::Commands::Saving

      def model
        @model ||= resolution.packed
      end

      def resolution
        universe.resolutions.by(identifier)
      end

      def space_name
        super || :packs
      end

    end
  end
end
