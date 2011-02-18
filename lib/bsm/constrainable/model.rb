module Bsm::Constrainable::Model
  extend ActiveSupport::Concern

  included do
    class_inheritable_accessor :_constrainable
    self._constrainable = {}
  end

  module ClassMethods

    def constrainable(name = nil, &block)
      name = name.present? ? name.to_sym : :default
      _constrainable[name] ||= Bsm::Constrainable::Schema.new
      _constrainable[name.to_sym].instance_eval(&block) if block
      _constrainable[name]
    end

  end
end