require_relative 'resource'

module Artifacts
  module Terraform
    module Aws
      class LoadBalancerTargetGroupStanza < ResourceStanza

    		def configuration_snippet =
          %(
            vpc_id = aws_vpc.#{arena_attachable_qualification_for(:vpc_binding)}.id
            protocol = "#{configuration.protocol}"
            target_type = "ip"
          )
          # %(
          #   vpc_id = aws_vpc.#{arena_attachable_qualification_for(:vpc_binding)}.id
          #   protocol = "#{configuration.protocol}"
          #   port = #{configuration.port}
          #   target_type = "ip"
          # )

        def more_snippets =
          %(
            health_check {
              healthy_threshold   = #{configuration.healthy_threshold}
              interval            = #{configuration.interval}
              protocol            = "#{configuration.protocol}"
              matcher             = #{configuration.matcher}
              timeout             = #{configuration.timeout}
              path                = "#{configuration.health_check_path}"
              unhealthy_threshold = #{configuration.unhealthy_threshold}
            }
          )

        def default_configuration =
          super.merge(
            description: application_identifier,
            vpc_binding: :vpc,
            target_type: "ip",
            healthy_threshold: 3,
            interval: 300,
            protocol: 'HTTP',
            matcher: 200,
            timeout: 3,
            unhealthy_threshold: 2,
            health_check_path: '/',
            path_pattern:  ["/*"]
          )

      end
    end
  end
end