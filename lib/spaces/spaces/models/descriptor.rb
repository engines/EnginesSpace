require 'addressable/uri'

require_relative 'model'

module Spaces
  class Descriptor < Model

    class << self
      def features; [:identifier, :repository, :branch, :protocol] ;end
    end

    attr_accessor :uri

    def identifier; struct.identifier || derived_features[:identifier] ;end

    def repository; uri.to_s ;end
    def branch; struct.branch || derived_features[:branch] ;end
    def protocol; struct.protocol || derived_features[:protocol] ;end
    def git?; protocol == 'git' ;end

    def initialize(args)
      self.uri = Addressable::URI.parse(args[:repository] || args[:struct]&.repository)
      self.struct = args[:struct] || OpenStruct.new(args)
    end

    def to_s
      [repository, branch, identifier].compact.join(' ')
    end

    protected

    def derived_features
      @derived_features ||= {
        identifier: root_identifier,
        branch: 'main',
        protocol: default_protocol
      }
    end

    def root_identifier; basename&.split('.')&.first ;end
    def basename; uri&.basename ;end

    def default_protocol
      ((e = uri&.extname).blank?) ? 'git' : e.gsub('.', '')
    end

  end
end
