require_relative 'model'
require_relative 'paths'
require_relative 'reading'
require_relative 'writing'
require_relative 'topology'

module Spaces
  class Space < Model
    include ::Spaces::Paths
    include ::Spaces::Reading
    include ::Spaces::Writing
    include ::Spaces::Topology

    class << self
      def universe
        @@universe ||= Universe.new
      end

      def default_model_class ;end
    end

    delegate([:identifier, :universe, :default_model_class] => :klass)

    def ensure_space
      path.mkpath
    end

    def all
      identifiers.map { |i| by(i) }
    end

    def simple_identifiers
      path.glob('*').map { |p| p.basename.to_s }
    end

    def identifiers(arena_identifier: '*', blueprint_identifier: '*')
      path.glob("#{arena_identifier}/#{blueprint_identifier}").map do |p|
        "#{p.relative_path_from(path)}".as_compound
      end
    end

    def exist?(identifiable)
      path_for(identifiable).exist?
    end

    def encloses?(file_name)
      file_name.exist?
    end

    def absent(array)
      array.reject { |r| exist?(r) }
    end

  end
end
