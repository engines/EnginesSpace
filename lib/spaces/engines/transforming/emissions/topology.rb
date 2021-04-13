module Emissions
  module Topology

    def graphed(**args)
      empty.tap do |m|
        m.struct = struct
        m.struct.tap do |s|
          s.bindings = bindings.graphed(**args).struct
        end
      end
    end

  end
end
