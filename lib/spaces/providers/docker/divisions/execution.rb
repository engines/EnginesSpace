module Providers
  module Docker
    class Execution < ::ProviderAspects::Execution #TODO: decide if we need empty classes

      def packing_artifact
        "CMD #{division.struct[:CMD]}"
      end

    end
  end
end