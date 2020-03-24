require_relative '../spaces/space'
require_relative 'git/space'
require_relative 'uri/space'

module Outer
  class Space < ::Spaces::Space

    class << self
      def git
        @@git ||= Outer::Git::Space.new
      end

      def uri
        @@uri ||= Outer::Uri::Space.new
      end

      def maps
        @@maps ||= {
          git: git,
          json: uri
        }
      end
    end

    def encloses?(descriptor)
      route(:encloses?, descriptor)
    end

    def by(descriptor)
      route(:by, descriptor)
    end

    def import(descriptor)
      route(:import, descriptor)
    end

    def file_names_for(directory, descriptor)
      maps[:"#{descriptor.extension}"].send(:file_names_for, directory, descriptor)
    end

    def route(method, descriptor)
      maps[:"#{descriptor.extension}"].send(method, descriptor)
    end

    def git
      self.class.git
    end

    def uri
      self.class.uri
    end

    def maps
      self.class.maps
    end

  end
end
