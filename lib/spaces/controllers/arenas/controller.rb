module Arenas
  module Controllers
    class Controller < ::Spaces::Controllers::RESTController

      def space_identifier; :arenas ;end

      def action_command_map
        @action_command_map ||= super.merge({
          create: Commands::Saving,
          state: Commands::StateReading,
          update: Commands::Saving,
          bind: Commands::Binding,
          more_binders: Commands::MoreBinders,
          install: Commands::Installing,
          resolve: Commands::Resolving,
          pack: Commands::Packing,
          runtime: Commands::RuntimeBooting,
          provision: Commands::Provisioning,
          provision_providers: Commands::ProviderProvisioning,
          init: [::Spaces::Commands::Executing, execute: :init],
          plan: [::Spaces::Commands::Executing, execute: :plan],
          apply: [::Spaces::Commands::Executing, execute: :apply],
        })
      end

    end
  end
end
