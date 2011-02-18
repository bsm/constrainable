module Bsm::Constrainable::Registry

  # Returns the current registry Hash
  def registry
    @registry ||= {}
  end

  # Register a class
  def register(klass)
    raise ArgumentError, "Already registered kind: #{klass.kind}" if registered?(klass.kind)
    registry[klass.kind] = klass
  end

  # Create a new object of a certain kind.
  def new(kind, *args)
    raise ArgumentError, "Invalid kind #{kind}" unless registered?(kind)
    registry[kind.to_sym].new(*args)
  end

  # Returns true if kind was already registered, else false
  def registered?(kind)
    registry.key?(kind.to_sym)
  end

end