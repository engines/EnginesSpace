require_relative 'subdivision'

module Divisions
  class TargetingSubdivision < Subdivision

    class << self
      def prototype(type:, struct:, division:)
        new(struct: struct, division: division)
      end
    end

    delegate(
      [:locations, :blueprints, :installations, :resolutions] => :universe
    )

    def blueprint
      @blueprint ||= blueprints.exist_then_by(descriptor)
    end

    def identifier; struct.identifier || target_identifier ;end
    def target_identifier; struct.target_identifier || descriptor&.identifier ;end

    def descriptor
      @descriptor ||= descriptor_class.new(
        struct.target || {identifier: struct.target_identifier}
      )
    end

    def installation; @installation ||= installation_in(arena) ;end
    def resolution; @resolution ||= resolution_in(arena) ;end

    def installation_in(arena); @installation ||= settlement_in(arena, installations) ;end
    def resolution_in(arena); @resolution ||= settlement_in(arena, resolutions) ;end

    def settlement_in(arena, space)
      space.exist_then(t = settlement_target_in(arena)) { space.by(t) }
    end

    def settlement_identifier
      settlement_identifier_in(arena)
    end
    alias_method :resolution_identifier, :settlement_identifier

    def settlement_target_in(arena)
      descriptor_class.new(identifier: settlement_identifier_in(arena))
    end

    def settlement_identifier_in(arena)
      "#{arena.identifier.with_identifier_separator}#{target_identifier}"
    end

  end
end