module Publishing
  module Controllers
    class Controller < ::Spaces::Controllers::RESTController

      def space_identifier; :publications ;end

      def import(**args)
        if r = (p = location_controller.update(**args)).result
          super(identifier: r)
        else
          p
        end
      end

      def action_command_map
        @action_command_map ||= super.merge({
          import: [::Publishing::Commands::Importing, force: true],
          export: ::Publishing::Commands::Exporting
        })
      end

      def location_controller
        @location_controller ||= ::Spaces::Controllers::RESTController.new(space: :locations)
      end

    end
  end
end
