module Identifiable

  def identifier; self.to_s ;end
  def context_identifier; identifier ;end

  def high; split_compound.first ;end
  def low; split_compound.last ;end

  def identifier_separator; '::' ;end
  def with_identifier_separator; identifier + identifier_separator ;end
  def as_path; gsub(identifier_separator, '/') ;end
  def as_compound(delimiter = '/'); gsub(delimiter, identifier_separator) ;end
  def split_compound; split(identifier_separator) ;end
  def subpath; nil ;end

  def as_subdomain
    split_compound.reverse.join('.').hyphenated
  end

  def complete?; true ;end

end
