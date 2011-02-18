class Bsm::Constrainable::Operation::Base
  extend ActiveSupport::Memoizable

  def self.kind
    name.demodulize.underscore.to_sym
  end

  attr_reader :value, :field, :relation

  def initialize(value, relation, field)
    @value    = value
    @relation = relation
    @field    = field
  end

  def parsed
    value.to_s
  end

  def valid?
    !invalid?
  end

  def invalid?
    wrap = Array.wrap(normalized)
    wrap.empty? || wrap.any?(&:nil?)
  end

  def clause
    valid? ? _clause : nil
  end
  memoize :clause

  protected

    def _clause
      attribute.send self.class.kind, normalized
    end

    def normalized
      field.convert(parsed)
    end
    memoize :normalized

    def attribute
      case field.attribute
      when Proc
        field.attribute.call(relation)
      else
        relation.table[field.attribute]
      end
    end
    memoize :attribute

end
