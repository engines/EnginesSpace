require_relative 'resource_stanza'

module Artifacts
  module Terraform
    module Aws
      class IamRolePolicyAttachmentStanza < ResourceStanza

        def configuration_snippet =
          %(
            role       = "#{configuration.role}"
            policy_arn = "#{configuration.role_arn}"
          )

      end
    end
  end
end
