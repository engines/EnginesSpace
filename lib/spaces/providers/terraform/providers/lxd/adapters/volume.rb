module Adapters
  module Terraform
    module Lxd
      class Volume < ::Adapters::Volume

        def snippets
          %(
            device {
              name = "#{volume_name}"
              type = "disk"
              properties = {
                path = "#{destination}"
                source = "#{volume_name}"
                pool = "#{pool_name}"
              }
            }
          )
        end

        def snippets_for(_)
          %(
            resource "lxd_volume" "#{volume_name}" {
              name = "#{volume_name}"
              pool = "#{pool_name}"
              remote = "lxd-server"
            }
          )
        end

        def volume_name; "#{blueprint_identifier}-#{source}" ;end
        def pool_name; "#{source}-pool" ;end

      end
    end
  end
end