module Commissioning
  class Service < ::Resolving::Emission
    include ::Transforming::Precedence

    class << self
      def composition_class; Composition ;end
    end

    relation_accessor :consumer

    delegate(runtime_provider: :arena)

    alias_method :provider, :runtime_provider

    def execute_for(milestone_name)
      interface.execute_commands_for(milestone_name)
    end

    def interface
      @interface ||= provider.interface_for(self, purpose: :service)
    end

    def commands_for(name)
      milestones_for(name).map { |m| "#{m.path}" }
    end

    def milestones_for(name)
      milestones.
        select { |m| m.name == name.to_s }.
        sort_by { |m| precedence.index(precedence_for(m.precedence.to_sym)) }
    end

    def parameters
      consumer.send(blueprint_identifier).service_string_array
    end

    def services
      precedence_file_names.map do |p|
        OpenStruct.new(
          service_identifier: identifier,
          name: milestone_identifier_from(p),
          precedence: precedence_from(p),
          path: container_path_from(p)
        )
      end
    end

    def container_path_from(precedence_path)
      "/#{precedence_path}".split('/').drop(1).join('/')
    end

    def precedence_from(precedence_path)
      "#{precedence_path}".split('/').first
    end

    def precedence_file_names
      resolutions.precedence_file_names_for(:servicing, identifier)
    end

    def milestone_identifier_from(path)
      path.basename.to_s.split('_').first
    end

  end
end
