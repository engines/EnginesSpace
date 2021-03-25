require_relative 'division'

module Divisions
  class Packers < ::Divisions::Division
    include ::Packing::Division

    alias_method :pack, :emission

    delegate(
      resolutions: :universe,
      resolution: :pack
    )

    def complete_precedence
      by_precedence(packing_divisions.map(&:keys).flatten.uniq)
    end

    def packing_divisions
      @packing_divisions ||= [resolution.packing_divisions, scripts_division].flatten.compact
    end

    def scripts_division
      @scripts_division ||=
        if source_path_for(:packing).join('scripts').exist?
          scripts_class.prototype(emission: pack, label: :scripts)
        end
    end

    def packing_payload; packing_payloads.map(&:to_h) ;end

    def packing_payloads
      [auxiliary_files_payload, precedential_payload].flatten.compact
    end

    def auxiliary_files_payload
      auxiliary_folders.map do |f|
        if source_path_for(f).exist?
          {
            type: 'file',
            source: "#{source_path_for(f)}/",
            destination: 'tmp'
          }
        end
      end
    end

    def precedential_payload
      complete_precedence.map { |p| payloads_for(p) }
    end

    def payloads_for(precedence)
      [file_copy_payload_for(precedence), division_payload_for(precedence)]
    end

    def division_payload_for(precedence)
      packing_divisions.map { |d| d.packing_payload_for(precedence) if d.uses?(precedence) }
    end

    def file_copy_payload_for(precedence)
      auxiliary_folders.map do |f|
        if copy_source_path_for(f, precedence).exist?
          {
            type: 'shell',
            inline: [
              "chown -R root:root /tmp/#{f}/#{precedence}/",
              "tar -C /tmp/#{f}/#{precedence}/ -cf - . | tar -C / -xf -"
            ]
          }
        end
      end
    end

    def scripts_class; ::Packing::Scripts ;end

  end
end