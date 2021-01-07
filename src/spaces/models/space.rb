require_relative 'model'

module Spaces
  class Space < Model

    include Engines::Logger

    class << self
      def universe = @@universe ||= Universe.new

      def default_model_class = nil
    end

    delegate([:identifier, :universe, :default_model_class] => :klass)

    def identifiers = path.glob('*').map { |p| p.basename.to_s }

    def all(klass = default_model_class) = identifiers.map { |i| by(i, klass) }

    def by_yaml(identifier, klass = default_model_class)
      klass.new(identifier: identifier, struct: klass.from_yaml(_by(identifier, klass, as: :yaml)))
    end

    alias_method :by, :by_yaml

    def by_json(identifier, klass = default_model_class)
      klass.new(identifier: identifier, struct: open_struct_from_json(_by(identifier, klass, as: :json)))
    end

    def save_text(model)
      _save(model, content: model.content)
      Pathname.new(writing_name_for(model)).chmod(model.permission) if model.respond_to?(:permission)
    end

    def save_yaml(model)
      _save(model, content: model.to_yaml, as: :yaml)
    end

    alias_method :save, :save_yaml

    def save_json(model)
      _save(model, content: model.emit.to_h_deep.to_json, as: :json)
    end

    def delete(model)
      path.join(model.identifier).rmtree
    end

    def reading_name_for(identifier, klass = default_model_class)
      path.join(identifier, klass.qualifier)
    end

    # FIXME: the permissions should be passed in
    def writing_name_for(model)
      ensure_space_for(model)

      "#{path_for(model)}/#{model.file_name}".tap do |p|
        logger.debug("Saving model with perms [#{permission(model)}]: #{p}")
      end
    end

    def file_names_for(directory, identifier)
      file_path_for(directory, identifier).glob('**/*').reject(&:directory?)
    end

    def file_path_for(symbol, context_identifier)
      path.join("#{context_identifier}", "#{symbol}")
    end

    def path_for(model)
      path.join(model.context_identifier, model.subpath)
    end

    def path = universe.path.join(identifier)

    def ensure_space = path.mkpath

    def ensure_space_for(model) = path_for(model).mkpath

    def encloses?(file_name) = file_name.exist?

    def _by(identifier, klass = default_model_class, as:)
      Pathname.new("#{reading_name_for(identifier, klass)}.#{as}").read
    end

    def _save(model, content:, as: nil)
      model.tap do |m|
        Pathname.new([writing_name_for(m), as].compact.join('.')).write(content)
      end
      model.identifier
    end

    private

    def permission(model)
      sprintf "%o", model.permission if model.respond_to?(:permission)
    end

  end
end
