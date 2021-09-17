module Spaces
  module Paths

    def path
      workspace.join("#{universes.identifier}", "#{identifier}")
    end

    def workspace; Pathname(ENV['ENGINES_WORKSPACE'] || default_workspace) ;end
    def default_workspace; Pathname(ENV['TMP'] || '/tmp').join('spaces') ;end

    def reading_path_for(identifiable, klass = default_model_class)
      path.join(identifiable.identifier.as_path, klass.qualifier)
    end

    def writing_path_for(identifiable)
      path.join(*([identifiable.context_identifier.as_path, identifiable.subpath].compact))
    end

    def streaming_path_for(identifiable)
      workspace.join("#{universes.identifier}", "#{default_streaming_location}", "#{identifier}")
    end

    def path_for(identifiable)
      path.join(identifiable.context_identifier.as_path)
    end

    def file_names_for(directory, identifier)
      file_path_for(directory, identifier).glob('**/*').reject(&:directory?)
    end

    def file_path_for(symbol, context_identifier)
      path.join("#{context_identifier.as_path}", "#{symbol}")
    end

  end
end