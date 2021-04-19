require_relative 'modelling'

module Spaces
  module Commands
    class Reading < Modelling

      alias_method :model, :current_model
      alias_method :assembly, :model

    end
  end
end
