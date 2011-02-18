require "active_support/core_ext"

module Bsm
  module Constrainable
    autoload :Util,       "bsm/constrainable/util"
    autoload :Model,      "bsm/constrainable/model"
    autoload :Relation,   "bsm/constrainable/relation"
    autoload :Schema,     "bsm/constrainable/schema"
    autoload :Registry,   "bsm/constrainable/registry"
    autoload :Field,      "bsm/constrainable/field"
    autoload :Operation,  "bsm/constrainable/operation"
    autoload :Filter,     "bsm/constrainable/filter"
  end
end

ActiveRecord::Base.class_eval do
  include Bsm::Constrainable::Model
end

ActiveRecord::Relation.class_eval do
  include Bsm::Constrainable::Relation
end
