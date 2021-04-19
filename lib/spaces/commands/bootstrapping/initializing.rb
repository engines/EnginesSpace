module Bootstrapping
  module Commands
    class Initializing < ::Arenas::Commands::Saving

      def model
        @model ||= current_model.bootstrapped_with(blueprint_identifier)
      end

      def blueprint_identifier
        input[:blueprint_identifier]
      end

      protected

      def commit
        space.save_initial(model)
        super
      end

    end
  end
end
