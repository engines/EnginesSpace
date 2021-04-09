require_relative 'division'

module Packing
  class Scripts < ::Divisions::Division
    include ::Packing::Division

    alias_method :pack, :emission

    delegate(resolutions: :universe)

    def scripts_for(precedence)
      resolutions.file_names_for("#{path}/#{precedence}", context_identifier).map(&:basename)
    end

    def keys
      keys ||= precedence & folders.map { |d| :"#{d.basename}" }
    end

    def folders
      folders ||= resolutions.path_for(pack).join(path).children.select(&:directory?)
    end

    def packing_artifact_for(precedence)
      {
        type: 'shell',
        inline: scripts_for(precedence).map do |s|
          temporary_script_path.join("#{precedence}", s)
        end
      }
    end

  end
end
