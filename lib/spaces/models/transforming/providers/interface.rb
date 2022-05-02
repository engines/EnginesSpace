module Providers
  class Interface < ::Spaces::Model

    relation_accessor :emission
    relation_accessor :stream

    def uniqueness; [klass.name, emission&.identifier] ;end

    def execute(instruction, **args); send(instruction, **args) ;end

    def initialize(emission, stream: nil)
      self.emission = emission
      self.stream = stream
    end

  end
end
