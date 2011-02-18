# Extension for ActiveRecord::Relation
module Bsm::Constrainable::Relation

  # Apply contraints. Example:
  #
  #   Post.constrain("created_at" => { "lt" => "2011-01-01" }})
  #
  # You can also combine it with multiple scopes:
  #
  #   Post.archived.includes(:author).constrain(params[:where]).paginate :page => 1
  #
  def constrain(*args)
    params = args.extract_options!
    schema = @klass.constrainable(args.first)
    schema.merge self, params
  end

end
