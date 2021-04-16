module Providers
  class Lxd < ::Providers::Provider
    class Container < ::Providers::Container

      def resolution_stanzas_for(_)
        %(
          resource "#{container_type}" "#{blueprint_identifier}" {
            name      = "#{blueprint_identifier}"
            image     = "lxd-server:#{image_name}"
            ephemeral = false
            profiles = ["default"]

            #{dependency_stanza}

            device {
              name  = "root"
              type  = "disk"

              properties  = {
                "path" = "/"
                "pool" = "default"
              }
            }

            #{connect_services_stanzas}
            #{commissioning_stanzas}
            #{device_stanzas}

            config = {
              "boot.autostart" = true
            }
          }
        )
      end

      def dependency_stanza
        %(depends_on=[#{dependency_string}]) if connections_down.any?
      end

      def connect_services_stanzas
        connect_bindings.map do |c|
          r = c.resolution
          if r.has?(:service_tasks)
            r.service_tasks.connection_stanza_for(c)
          end
        end.compact.join
      end

      def commissioning_stanzas
        commissioning_scripts.map do |s|
          %(
            provisioner "local-exec" {
              command = "lxc exec #{blueprint_identifier} #{s}"
            }
          )
        end.join
      end

      def device_stanzas
        emission.volumes.all.map(&:device_stanzas).join
      end

      def dependency_string
        connections_down.map { |c| "#{container_type}.#{c.blueprint_identifier}" }.join(', ')
      end

    end
  end
end
