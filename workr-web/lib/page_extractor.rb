class PageExtractor
  def self.extract(url)
    api = Embedly::API.new
    api.extract(url: url).first
  end
end
