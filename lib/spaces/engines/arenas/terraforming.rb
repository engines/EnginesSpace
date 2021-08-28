require 'ruby_terraform'

module Arenas
  module Terraforming

    def init(model, &block); execute(:init, model, &block) ;end
    def plan(model, &block); execute(:plan, model, &block) ;end
    def show(model, &block); execute(:show, model, &block) ;end
    def apply(model, &block); execute(:apply, model, &block) ;end

    protected

    def execute(command, model, &block)
      Dir.chdir(path_for(model)) do
        Emit.new(&block).open do |t|
          # TODO: USE bridge.send(command, options[command] || {})
          Object
          .const_get("RubyTerraform::Commands::#{command.camelize}")
          .new(stdout: t, stderr: t)
          .execute
        end
      end
    rescue RubyTerraform::Errors::ExecutionError => e
      raise ::Arenas::Errors::ProvisioningError, {execute: command, error: e}
    end

    def bridge; RubyTerraform ;end

    def options
      {
        plan: {
          input: false
        },
        apply: {
          input: false,
          auto_approve: true
        }
      }
    end

  end
end
