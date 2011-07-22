# Includable module, for ActiveRecord::Base
module Bsm::Constrainable::Model
  extend ActiveSupport::Concern

  included do
    class_inheritable_accessor :_constrainable
    self._constrainable = {}
  end

  module ClassMethods

    # Constraint definition for a model. Example:
    #
    #   class Post < ActiveRecord::Base
    #
    #     constrainable do
    #       # Add your default constraints
    #     end
    #
    #     constrainable :custom do
    #       # Add your custom constraints
    #     end
    #
    #   end
    #
    def constrainable(name = nil, &block)
      name = name.present? ? name.to_sym : :default
      _constrainable[name] ||= Bsm::Constrainable::Schema.new(self)
      _constrainable[name.to_sym].instance_eval(&block) if block
      _constrainable[name]
    end

    # Delegator to Relation#constrain
    def constrain(*args)
      scoped.constrain(*args)
    end

  end
end