require_relative 'capsule_summary'

module Providers
  module Docker
    class Capsule < CapsuleSummary

      delegate([:running, :paused] => :state)

      def summary
        @summary ||= super.merge(
          OpenStruct.new(
            status: state.status,
            state: state.to_h
          )
        )
      end

      def toggle_start
        return unpause if paused
        return restart if running
        model_interface.start
      end

      def toggle_pause
        paused ? unpause : pause
      end

      def image_id; image ;end
      def names; [struct.name] ;end

    end
  end
end
