module Artifacts
  module Terraform
    module Aws
      module TaskDefining

        def configuration_hash
          super.without(*task_definition_keys)
        end

        def task_definition_keys
          [
            :essential,
          ]
        end

      end
    end
  end
end