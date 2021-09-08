module Publishing
  module Commands
    class Importing < ::Spaces::Commands::Saving

      delegate(locations: :universe)

      def model
        @model ||=
          super.well_formed? ? super : locations.by(identifier)
      end

      def force
        input[:model][:force] || false
      end

      def space_identifier
        super || :publications
      end

      def model_class
        locations.default_model_class
      end

      protected

      def commit(&block)
        locations.save(model)
        space.import(model, force: force, &block)
      end

    end
  end
end
