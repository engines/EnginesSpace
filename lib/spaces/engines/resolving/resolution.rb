require_relative 'flattening'
require_relative 'packing'
require_relative 'provisioning'

module Resolving
  class Resolution < ::Emissions::Emission
    include Resolving::Flattening
    include Resolving::Packing
    include Resolving::Provisioning

    class << self
      def composition_class; Composition ;end
    end

    delegate(
      runtime_binding: :arena,
      resolutions: :universe,
      [:arenas, :blueprints] => :resolutions
    )

    def arena; @arena ||= arenas.by(arena_identifier) ;end

    def arena_identifier; identifier.split('/').first ;end

    alias_accessor :blueprint, :predecessor
    alias_accessor :binder, :predecessor

    def complete?
      all_complete?(divisions)
    end

    def connections_resolved
      connections_down(emission: :blueprint).map { |c| c.with_embeds.resolved_in(arena) }
    end

    def embeds_including_blueprint; [blueprint, embeds_down].flatten.compact.reverse ;end

    def content_into(directory, source:)
      resolutions.file_names_for(directory, source.context_identifier).map do |t|
        Interpolating::FileText.new(origin: t, directory: directory, transformable: self)
      end
    end

    def empty; super.tap { |m| m.arena = arena } ;end

  end
end
