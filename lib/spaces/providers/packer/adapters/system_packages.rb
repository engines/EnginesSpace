module Providers
  module Packer
    class SystemPackages < ::Adapters::SystemPackages

      def snippets_for(key)
        {
          type: 'shell',
          environment_vars: "SYSTEM_PACKAGE_#{key.upcase}=#{division.send(key)&.join(' ')}",
          inline: ["#{temporary_script_path}/#{qualifier}/#{key}"]
        }
      end

    end
  end
end