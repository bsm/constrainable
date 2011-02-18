module Bsm::Constrainable::Registry

  def registry
    @registry ||= {}
  end

  def register(klass)
    raise ArgumentError, "Already registered kind: #{klass.kind}" if registered?(klass.kind)
    registry[klass.kind] = klass
  end

  def new(kind, *args)
    raise ArgumentError, "Invalid kind #{kind}" unless registered?(kind)
    registry[kind.to_sym].new(*args)
  end

  def registered?(kind)
    registry.key?(kind.to_sym)
  end

end