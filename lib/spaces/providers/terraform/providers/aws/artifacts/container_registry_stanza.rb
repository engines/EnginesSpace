require_relative 'capsule_stanza'

module Artifacts
  module Terraform
    module Aws
      class ContainerRegistryStanza < CapsuleStanza

        def more_snippets
          %(
            resource "aws_ecr_repository_policy" "#{application_identifier}" {
              repository = aws_ecr_repository.#{application_identifier}.name
              policy     = <<EOF
              {
                "Version": "2008-10-17",
                "Statement": [
                  {
                    "Sid": "adds full ecr access to the demo repository",
                    "Effect": "Allow",
                    "Principal": "*",
                    "Action": [
                      "ecr:BatchCheckLayerAvailability",
                      "ecr:BatchGetImage",
                      "ecr:CompleteLayerUpload",
                      "ecr:GetDownloadUrlForLayer",
                      "ecr:GetLifecyclePolicy",
                      "ecr:InitiateLayerUpload",
                      "ecr:PutImage",
                      "ecr:UploadLayerPart"
                    ]
                  }
                ]
              }
              EOF
            }
          )
        end

      end
    end
  end
end