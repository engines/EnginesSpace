module Arenas
  module Commands
    class Resolving < ::Arenas::Commands::Saving

      alias_method :model, :current_model

      protected

      def commit
        space.update_resolutions_for(model)
      end

    end
  end
end
