class Bsm::Constrainable::Schema < Hash
  include ::Bsm::Constrainable::Util
  Field = ::Bsm::Constrainable::Field

  def initialize(klass)
    @klass = klass
    super()
  end

  def fields(*names)
    options = names.extract_options!
    names.map(&:to_s).each do |name|
      column = @klass.columns_hash[name]
      raise ArgumentError, "Invalid field #{name}" unless column
      raise ArgumentError, "Invalid field type #{column.type}" unless Field.registered?(column.type)
      match name, options.merge(:as => column.type)
    end
  end

  def match(*names)
    options = names.extract_options!
    kind    = options.delete(:as)
    names.map(&:to_s).each do |name|
      self[name] ||= []
      self[name] << Field.new(kind, name, options)
    end
  end
  alias_method :field, :match

  def respond_to?(sym)
    super || Field.registered?(sym)
  end

  def merge(relation, params)
    each_part(params) do |name, part|
      self[name].each do |constrain|
        relation = constrain.merge(relation, part)
      end
    end
    relation
  end

  protected

    def method_missing(sym, *args)
      if Field.registered?(sym)
        opts = args.extract_options!.merge(:as => sym)
        match(*(args << opts))
      else
        super
      end
    end

  private

    def each_part(params)
      params = normalized_hash(params)
      params.slice(*keys).each do |name, part|
        yield(name, part.symbolize_keys) if part.is_a?(Hash)
      end
    end

end