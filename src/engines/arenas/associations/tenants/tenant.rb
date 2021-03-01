module Associations
  class Tenant < ::Divisions::Association

    class << self
      def default_struct
        OpenStruct.new(identifier: 'engines')
      end
    end

  end
end
