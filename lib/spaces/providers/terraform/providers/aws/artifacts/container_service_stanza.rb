require_relative 'capsule_stanza'
require_relative 'task_defining'

module Artifacts
  module Terraform
    module Aws
      class ContainerServiceStanza < CapsuleStanza
        include Named
        include TaskDefining

        def more_snippets =
          %(
            cluster = aws_ecs_cluster.#{configuration.cluster_binding}.id
            iam_role = aws_iam_role.#{configuration.iam_role_binding}.arn
            task_definition = aws_ecs_task_definition.#{configuration.task_definition_binding}.arn
            ordered_placement_strategy {
              type  = "binpack"
              field = "cpu"
            }
			load_balancer {
    		target_group_arn = aws_lb_target_group.#{configuration.load_balancer_target_group}.arn
    		container_name   = "#{application_identifier}"
    		container_port   = #{configuration.port}
  			}
          )

        def configuration_hash =
          super.without(:cluster_binding, :iam_role_binding, :task_definition_binding)

        def default_configuration =
          OpenStruct.new(
            cluster_binding: :'container-service-cluster',
            iam_role_binding: :'iam-role',
            task_definition_binding: :'container-task-definition',
            launch_type: :'FARGATE'
          )

      end
    end
  end
end
