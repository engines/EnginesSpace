require 'git'
require_relative 'importing'
require_relative 'exporting'

module Spaces
  module Git
    class Repository < ::Spaces::Model
      include Engines::Logger
      include Importing
      include Exporting

      relation_accessor :descriptor
      relation_accessor :space

      delegate(
        [:repository_name, :identifier, :branch_name, :remote] => :descriptor,
        [:branch, :checkout] => :opened
      )

      def branch_names_without_head
        opened.branches.map(&:name).uniq.reject { |b| b.include?(head_identifier) }
      end

      alias_method :branch_names, :branch_names_without_head

      def opened
        @opened ||= git.open(space.path_for(descriptor), log: logger)
      end

      def raise_failure_for(exception)
        raise failure, {message: exception.message}
      end

      def git; ::Git ;end
      def git_error; ::Git::GitExecuteError ;end
      def failure; ::Spaces::Errors::RepositoryFail ;end
      def head_identifier; 'HEAD ->' ;end

      def initialize(descriptor, space:)
        self.descriptor = descriptor
        self.space = space
      end

    end
  end
end
