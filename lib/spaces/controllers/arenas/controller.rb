module Arenas
  module Controllers
    class Controller < ::Spaces::Controllers::RESTController

      def space_identifier; :arenas ;end

      def action_command_map
        @action_command_map ||= super.merge({
          install: [::Arenas::Commands::Installing, force: true],
          resolve: [::Arenas::Commands::Resolving, force: true],
          pack: [::Arenas::Commands::Packing, force: true],
          provision: Arenas::Commands::Provisioning,
          apply: [::Spaces::Commands::Executing, execute: :apply]
        })
      end

    end
  end
end