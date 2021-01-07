require_relative 'requires'

class Universe < ::Spaces::Space

  class << self
    def space_map
      @@space_map ||=
      {
        blueprints: Blueprinting::Space.new,
        resolutions: Resolving::Space.new,
        packing: Packing::Space.new,
        provisioning: Provisioning::Space.new,
        arenas: Arenas::Space.new,

        domains: Associations::Domains::Space.new,
        tenants: Associations::Tenants::Space.new
      }
    end
  end

  def path = workspace.join(identifier)

  def workspace = Pathname(ENV['ENGINES_WORKSPACE'] || default_workspace)
  def default_workspace = Pathname(ENV['TMP'] || '/tmp').join('spaces')

  def host = 'spaces.internal'

  def method_missing(m, *args, &block) = klass.space_map[m] || super

  def respond_to_missing?(m, *) = klass.space_map[m] || super

end
