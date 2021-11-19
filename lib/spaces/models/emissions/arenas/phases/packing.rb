module Arenas
  module Packing

    def all_packs
      packs.identifiers(arena_identifier: identifier).map do |i|
        packs.by(i)
      end
    end

    def packed; present_in(packs) ;end

    def unpacked
      absent_in(packs).select { |b| b.resolution_in(arena)&.packable? }
    end

    def unsaved_packs; packables.reject(&:packed?) ;end
    def packables; bound_resolutions.select(&:packable?) ;end # NOW WHAT?

  end
end
