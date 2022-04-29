module Publishing
  module Commands
    class Importing < ::Spaces::Commands::Saving
      include ::Streaming::Streaming

      delegate(locations: :universe)

      def model
        @model ||=
          super.well_formed? ? super : locations.by(identifier)
      end

      def model_class
        locations.default_model_class
      end

      def stream_elements; [space.identifier, model.identifier, qualifier] ;end

      protected

      def commit
        locations.save(model)
        with_streaming do
          space.import(model, force: force, stream: stream)
        end
      end

    end
  end
end
