require_relative 'resource_stanza'

module Artifacts
  module Terraform
    module Aws
      class SecurityGroupStanza < ResourceStanza

        def more_snippets =
          %(
            ingress {
              from_port        = 8501
              to_port          = 8501
              protocol         = "tcp"
              cidr_blocks      = ["0.0.0.0/0"]
              ipv6_cidr_blocks = ["::/0"]
            }

            egress {
              from_port        = 0
              to_port          = 0
              protocol         = "-1"
              cidr_blocks      = ["0.0.0.0/0"]
              ipv6_cidr_blocks = ["::/0"]
            }
          )

      end
    end
  end
end
