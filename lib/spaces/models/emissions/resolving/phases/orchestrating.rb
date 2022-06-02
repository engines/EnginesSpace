module Resolving
  module Orchestrating

    def orchestrated
      empty_orchestration.tap do |m|
        m.predecessor = self
        m.cache_identifiers!
      end
    end

    def orchestrated?
      orchestrations.exist?(identifier)
    end

    def empty_orchestration; orchestration_class.new ;end
    def orchestration_class; ::Orchestrating::Orchestration ;end

  end
end
