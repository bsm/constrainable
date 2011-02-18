module Bsm::Constrainable::Relation

  def constrain(*args)
    params = args.extract_options!
    schema = @klass.constrainable(args.first)
    schema.merge self, params
  end

end
