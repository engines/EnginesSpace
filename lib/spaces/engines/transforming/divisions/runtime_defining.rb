require_relative 'provider_dependent'

module Divisions
  module RuntimeDefining
    include ProviderDependent

    def aspect_name_elements
      [super, runtime_identifier, qualifier].flatten
    end

    def resolution_stanzas_for(_)
      unless self == provider_aspect
        provider_aspect.resolution_stanzas_for(_)
      else
        super
      end        
    end

  end
end
