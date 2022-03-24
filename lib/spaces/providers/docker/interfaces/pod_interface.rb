require_relative 'interface'

module Providers
  module Docker
    class PodInterface < Interface

      def execute(command)
        container.send(command)
      end

      def by_image_id(image_id)
        all.select { |c| c.image_id == image_id }.reverse
      end

      def by_spaces_identifier(identifier)
        all.select { |c| c.spaces_identifier == identifier }.reverse
      end

      def bridge; ::Docker::Container ;end
      def model_class; Pod ;end
      def summary_class; PodSummary ;end

    end
  end
end