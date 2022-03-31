module Resolving
  module Imaging

    def to_image
      empty_image.tap do |m|
        m.struct.identifier = identifier
        m.cache_primary_identifiers
      end
    end

    def empty_image; image_class.new ;end
    def image_class; ::Images::Image ;end

  end
end