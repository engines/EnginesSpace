module Packing
  module Division

    def precedence = [:first, :early, :adds, :middle, :late, :removes, :last]

    def precedence_midpoint = precedence.count / 2

    def embed!(other)
      tap do
        keys_including(other).each do |k|
          struct[k] = [other.struct[k], struct[k]].flatten.compact.uniq
        end
      end
    end

    def keys_including(other)
      by_precedence([other.keys, keys].flatten.uniq)
    end

    def packing_source_path
      resolutions.file_path_for(:packing, context_identifier)
    end

    def copy_source_path_for(precedence)
      packing_source_path.join("#{precedence}")
    end

    def temporary_script_path
      Pathname('tmp').join('packing', 'scripts', qualifier)
    end

    def keys = by_precedence(super)

    def by_precedence(keys)
      keys.sort_by { |k| precedence.index(k) || precedence_midpoint }
    end

  end
end
