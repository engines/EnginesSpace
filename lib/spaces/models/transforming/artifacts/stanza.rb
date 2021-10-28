require_relative 'artifact'

module Artifacts
  class Stanza < Artifact

    alias_method :artifact, :holder

    def method_missing(m, *args, &block)
      return artifact.send(m, *args, &block) if artifact.respond_to?(m)
      super
    end

    def respond_to_missing?(m, *)
      artifact.respond_to?(m) || super
    end

  end
end
