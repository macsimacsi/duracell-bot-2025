# module StringExtensions
class String
  def slugify
    downcase.gsub('&', 'y').parameterize.gsub(/[^0-9a-z-]+/i, '')
  end

  def plural(count = nil)
    pluralize(count, I18n.locale || :en)
  end
end
