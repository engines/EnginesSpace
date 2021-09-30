module Providers
  module Docker
    class Packers < ::ProviderAspects::Packers

      delegate script_path: :division

      def packing_stanza; packing_stanzas.compact.join("\n") ;end

      def auxiliary_file_stanza_for(path)
        "ADD #{script_path}/ #{temporary_script_path}/" if path.basename.to_s == 'packing'
      end

      def file_copy_stanza_for(folder, precedence)
        "ADD #{folder}/#{precedence}/ /"
      end

    end
  end
end
