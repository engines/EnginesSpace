require_relative 'collaboration'

module Projects
  class Stage < Collaboration

    delegate([:identifier, :home_app_path] => :assembly)

    def initialize(struct:, assembly:)
      self.assembly = assembly
      self.struct = duplicate(struct)
    end

  end
end
