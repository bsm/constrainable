# Schema definition.
class Bsm::Constrainable::Schema < Hash
  Field = ::Bsm::Constrainable::Field

  def initialize(klass)
    @klass = klass
    super()
  end

  # Define multiple constrainable columns. Expects 1-n column names (must be
  # real columns) and an options Hash. Examples:
  #
  #   fields :id
  #   fields :id, :author_id
  #   fields :id, :author_id, :with => [:in, :not_in]
  #
  def fields(*names)
    options = names.extract_options!
    names.map(&:to_s).each do |name|
      column = @klass.columns_hash[name]
      raise ArgumentError, "Invalid field #{name}" unless column
      raise ArgumentError, "Invalid field type #{column.type}" unless Field.registered?(column.type)
      match name, options.merge(:as => column.type)
    end
  end

  # Define constrainable names (don't have to be real columns). Expects 1-n
  # names and an options Hash. Options, must specify the type via <tt>:as</tt>.
  # Examples:
  #
  #   # One match
  #   match :id, :as => :number
  #
  #   # Multiple matches
  #   match :id, :author_id, :as => :integer, :with => [:in, :not_in]
  #
  #   # Use a specific column
  #   match :created, :using => :created_at, :as => :timestamp, :with => [:lt, :between]
  #
  #   # Complex example, using an attribute from another table, and ensure it's included (LEFT OUTER JOIN)
  #   match :author, :using => proc { Author.scope.table[:name] }, :scope => { includes(:author) }, :as => :string, :with => [:eq, :matches]
  #
  # There are also several short-cuts available. Examples:
  #
  #   timestamp :created, :using => :created_at, :with => [:lt, :between]
  #   number    :id, :author_id
  #   string    :title, :with => [:eq, :matches]
  #
  def match(*names)
    options = names.extract_options!
    kind    = options.delete(:as)
    names.map(&:to_s).each do |name|
      self[name] ||= []
      self[name] << Field.new(kind, name, options)
    end
  end
  alias_method :field, :match

  # Creates a FilterSet object for given params. Filter-sets can be used to
  # constrain relations as well as e.g. in forms. Example:
  #
  #   filters = Post.constrainable.filter(params[:where])
  #   Post.archived.constrain(filters).limit(100)
  #
  def filter(params = nil)
    Bsm::Constrainable::FilterSet.new self, params
  end

  def respond_to?(sym)
    super || Field.registered?(sym)
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

end