# Abstract field type
class Bsm::Constrainable::Field::Base
  DEFAULT_OPERATORS = [:eq, :not_eq, :gt, :gteq, :lt, :lteq, :between].freeze

  class_attribute :operators, :defaults, :instance_reader => false, :instance_writer => false
  self.operators = DEFAULT_OPERATORS.dup
  self.defaults  = [:eq, :not_eq]

  # Returns the field type/kind, e.g. <tt>:string</tt> or <tt>:integer</tt>
  def self.kind
    @kind ||= name.demodulize.underscore.to_sym
  end

  attr_reader :name, :operators, :attribute, :scope

  # Accepts a name and options. Valid options are:
  # * <tt>:using</tt> - a Symbol or a Proc pointing to a DB column, optional (uses name by default)
  # * <tt>:with</tt> - a list of operators to use
  # * <tt>:scope</tt> - a Proc containing additional scopes
  #
  # Examples:
  #
  #   Field::Integer.new :id
  #   Field::Integer.new :uid, :using => :id
  #   Field::Integer.new :uid, :using => proc { Model.scoped.table[:col_name] }
  #   Field::String.new :name, :with => [:matches]
  #   Field::String.new :author, :with => [:matches], :using => proc { Author.scoped.table[:name] }, :scope => proc { includes(:author) }
  #
  def initialize(name, options = {})
    @name      = name.to_s
    @attribute = options[:using] || name
    @operators = Set.new(self.class.operators & Array.wrap(options[:with]))
    @operators = Set.new(self.class.defaults) if @operators.empty?
    @scope     = options[:scope]
  end

  # Merge params into a relation
  def merge(relation, operator, value)
    operator = operator.to_sym
    return relation unless operators.include?(operator)

    operation = Bsm::Constrainable::Operation.new(operator, value, relation, self)
    return relation if operation.clause.nil?

    relation = relation.instance_eval(&scope) if scope
    relation.where(operation.clause)
  end

  def convert(value)
    value.is_a?(Array) ? value.map {|v| convert(v) } : _convert(value)
  end

  protected

    def _convert(value)
      value.to_s
    end

end