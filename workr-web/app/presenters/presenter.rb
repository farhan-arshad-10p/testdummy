class Presenter
  attr_reader :source, :extras

  def initialize(source, extras={})
    @source = source
    @extras = extras
  end

  def self.present(source, extras={})
    return nil if source.nil?
    if source.respond_to?(:map) && !source.is_a?(String) && !source.is_a?(Hash)
      source.map{|obj| new obj, extras}
    else
      new source, extras
    end
  end
end
