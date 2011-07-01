class Bsm::Constrainable::FilterSet < Hash
  include ::Bsm::Constrainable::Util

  attr_reader :schema

  def initialize(schema, params = {})
    @schema = schema

    normalized_hash(params).slice(*schema.keys).each do |name, part|
      update name => part.symbolize_keys if part.is_a?(Hash)
    end
  end

  def merge(relation)
    each do |name, part|
      schema[name].each do |field|
        relation = field.merge(relation, part)
      end
    end
    relation
  end

  def respond_to?(sym, *)
    name, operator = sym.to_s.sub(NAME_OP, ''), $1
    super || (operator.nil? && schema.key?(name)) || valid_operator?(name, operator)
  end

  private
    NAME_OP = /\[(\w+)\]$/.freeze

    def method_missing(sym, *args)
      name, operator = sym.to_s.sub(NAME_OP, ''), $1

      if (operator.nil? && schema.key?(name))
        self[name]
      elsif valid_operator?(name, operator)
        self[name].try(:[], operator.to_sym)
      else
        super
      end
    end

    def valid_operator?(name, operator)
      return false unless operator.present? && schema.key?(name.to_s)

      schema[name].any? do |field|
        field.operators.include?(operator.to_sym)
      end
    end

end