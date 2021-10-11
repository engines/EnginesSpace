module Providers
  module Docker
    class Permission < ::Adapters::Permission

      delegate [:recursion, :ownership, :file, :mode] => :division

      def packing_snippet
        "RUN #{statements.join(connector)}"
      end

      def statements
        [
          ("chown #{recursion} #{ownership} #{file}" if ownership),
          ("chmod #{recursion} #{mode} #{file}" if mode)
        ].compact
      end

      def connector; " &\&\\\n  " ;end

    end
  end
end
