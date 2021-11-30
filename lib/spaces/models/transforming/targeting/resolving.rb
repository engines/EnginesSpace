module Targeting
  module Resolving

    def flattened
      empty.tap do |m|
        m.struct = struct.tap do |s|
          s.configuration = flattened_configuration
        end
      end
    end

    def flattened_configuration
      unresolved_struct.merge(target_configuration).merge(configuration)
    end

    def resolved
      super.tap do |d|
        d.struct.configuration = Divisions::ResolvableStruct.new(struct.configuration, self).resolved
      end
    end

    def configuration # NOW WHAT?
      struct.configuration || derived_features[:configuration]
    end

    def target_configuration # NOW WHAT?
      #TODO: can't use blueprint here ... must be more gerneric
      # #better_emission method?
      @target_configuration ||= blueprint.binding_target.struct
    end

    def infix_qualifier; target_identifier ;end

  end
end