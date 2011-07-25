class Bsm::Constrainable::FilterSet < Hash
  include ::Bsm::Constrainable::Util

  attr_reader :schema

  def initialize(schema, params = {})
    @schema = schema

    normalized_hash(params).each do |key, value|
      name, op = key.split('__')
      update(key => value) if valid_operation?(name, op)
    end
  end

  def merge(scoped)
    each do |key, value|
      name, op = key.split('__')
      schema[name].each do |field|
        scoped = field.merge(scoped, op, value)
      end
    end
    scoped
  end

  def respond_to?(sym, *)
    name, op = sym.to_s.split('__')
    super || valid_operation?(name, op)
  end

  private

    def method_missing(sym, *args)
    name, op = sym.to_s.split('__')
      if valid_operation?(name, op)
        self[sym.to_s]
      else
        super
      end
    end

    def valid_operation?(name, operator)
      return false unless operator.present? && schema.key?(name.to_s)

      schema[name].any? do |field|
        field.operators.include?(operator.to_sym)
      end
    end

end