require_relative 'model'

module Spaces
  class Product < Model
    # A model object generated by a tensor

    relation_accessor :tensor

    def identifier
      struct.software.title
    end

  end
end
