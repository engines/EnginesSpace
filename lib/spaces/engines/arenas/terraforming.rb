require 'ruby_terraform'

module Arenas
  module Terraforming
    include Spaces::Emitting::Lib

    def init(model, &block); execute(:init, model, &block) ;end
    def plan(model, &block); execute(:plan, model, &block) ;end
    def show(model, &block); execute(:show, model, &block) ;end
    def apply(model, &block); execute(:apply, model, &block) ;end

    protected

    def output_filepath(command, model)
      path_for(model).join("#{command}.out")
    end

    def execute(command, model, &block)
      Dir.chdir(path_for(model)) do
        emit_to(output_filepath(command, model), output_callback(&block)) do |emit|
          emit.info(color.green("\nTerraform #{command} start\n", bold: true))
          begin
            # TODO: USE bridge.send(command, options[command] || {})
            Object
            .const_get("RubyTerraform::Commands::#{command.camelize}")
            .new(stdout: emit, stderr: emit, logger: logger)
            .execute
            emit.info(color.green("Terraform #{command} complete\n", bold: true))
          rescue RubyTerraform::Errors::ExecutionError => e
            emit.info(color.red("Terraform #{command} error\n", bold: true))
            emit.info(color.red("#{e}\n"))
          ensure
            emit.close
          end
        end
      end
      command
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
