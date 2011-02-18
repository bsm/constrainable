class Bsm::Constrainable::Field::Base
  DEFAULT_OPERATORS = [:eq, :not_eq, :gt, :gteq, :lt, :lteq, :between].freeze

  class_inheritable_accessor :operators, :defaults, :instance_reader => false, :instance_writer => false
  self.operators = DEFAULT_OPERATORS.dup
  self.defaults  = [:eq, :not_eq]

  def self.kind
    @kind ||= name.demodulize.underscore.to_sym
  end

  attr_reader :name, :operators, :attribute, :scope

  def initialize(name, options = {})
    @name      = name.to_s
    @attribute = options[:using] || name
    @operators = Set.new(self.class.operators & Array.wrap(options[:with]))
    @operators = Set.new(self.class.defaults) if @operators.empty?
    @scope     = options[:scope]
  end

  def merge(relation, params)
    params.slice(*operators).each do |operator, value|
      operation = Bsm::Constrainable::Operation.new(operator, value, relation, self)
      next if operation.clause.nil?

      relation = relation.instance_eval(&scope) if scope
      relation = relation.where(operation.clause)
    end
    relation
  end

  def convert(value)
    value.is_a?(Array) ? value.map {|v| convert(v) } : _convert(value)
  end

  protected

    def _convert(value)
      value.to_s
    end

end