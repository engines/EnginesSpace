module Provisioning
  class Space < ::Spaces::Space

    class << self
      def default_model_class
        Provisions
      end
    end

    delegate([:arenas, :resolutions] => :universe)

    def cascade_deletes; [:registry] ;end

    def by(identifier, klass = default_model_class)
      super.tap do |m|
        m.resolution = resolutions.by(identifier)
      end
    end

    def save(model)
      ensure_connections_exist_for(model)
      if model.resolution.provisionable?
        arena_path(model).write(model.artifacts)
      end
      super
    end

    def delete(identifiable, cascade: true)
      super.tap do
        arena_path(identifiable.identifier).exist_then { delete }
      end
    end

    def arena_path(identifiable)
      Pathname.new("#{arenas.path}/#{identifiable.identifier.as_path}.#{arenas.artifact_extension}")
    end

    protected

    def ensure_connections_exist_for(model)
      model.connections_provisioned.each { |p| save(p) }
    end

  end
end
