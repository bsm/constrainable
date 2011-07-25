# Extension for ActiveRecord::Relation
module Bsm::Constrainable::Relation

  # Apply contraints. Example:
  #
  #   Post.constrain("created_at__lt" => "2011-01-01")
  #
  #   # Use "custom" constraints
  #   Post.constrain(:custom, "created_at__lt" => "2011-01-01")
  #
  #   # Combine it with relations & scopes
  #   Post.archived.includes(:author).constrain(params[:where]).paginate :page => 1
  #
  def constrain(*args)
    scope    = args.first.is_a?(Symbol) ? args.shift : nil
    filters  = args.last

    case filters
    when Bsm::Constrainable::FilterSet
      filters.merge(self)
    when Hash
      klass.constrainable(scope).filter(filters).merge(self)
    else
      self
    end
  end

end
