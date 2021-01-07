class String
  BLANK_RE = /\A[[:space:]]*\z/

  def camelize
    s = sub(/^[a-z\d]*/) { |match| match.capitalize }
    s.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    s.gsub!("/", "::")
    s
  end

  def snakize
    gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end

  alias_method :underscore, :snakize

  def singularize = chomp('s')

  def pluralize = "#{itself}s"

  def blank? = empty? || BLANK_RE.match?(self)

  def complete? = true
end
