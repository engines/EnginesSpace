module Spaces
  class Space < Model

    class << self
      def universes; @@universes ||= UniverseSpace.new ;end

      def universe; universes.universe ;end

      def default_model_class ;end
    end

    delegate([:universes, :default_model_class] => :klass)

    def identifier; struct.identifier ;end
    def space; itself ;end

    def summaries
      all.map(&:summary)
    end

    def exist_then(identifiable, &block)
      yield(identifiable) if block_given? && exist?(identifiable)
    end

    def absent(array)
      array.reject { |m| exist?(m) }
    end

    def interface_for(model)
      model.provider_for(provider_role).interface_for(model)
    end

    def initialize(identifier:)
      self.struct = OpenStruct.new(identifier: identifier.to_sym)
    end

    protected

    def raise_lost_error(identifiable)
      raise ::Spaces::Errors::LostInSpace, {space: self.identifier, identifier: identifiable&.identifier}
    end

  end
end
