module WithinHelpers
  def my
    @my ||= My.new
  end

  def their
    @their ||= My.new
  end

  def repository
    @repository ||= Repository.new(self)
  end

  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)
