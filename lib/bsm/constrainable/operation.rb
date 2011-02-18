module Bsm::Constrainable::Operation
  extend Bsm::Constrainable::Registry

  autoload :Base, 'bsm/constrainable/operation/base'
  autoload :Collection, 'bsm/constrainable/operation/collection'
  autoload :Eq,      'bsm/constrainable/operation/common'
  autoload :NotEq,   'bsm/constrainable/operation/common'
  autoload :Gt,      'bsm/constrainable/operation/common'
  autoload :Lt,      'bsm/constrainable/operation/common'
  autoload :Gteq,    'bsm/constrainable/operation/common'
  autoload :Lteq,    'bsm/constrainable/operation/common'
  autoload :Matches, 'bsm/constrainable/operation/common'
  autoload :In,      'bsm/constrainable/operation/in'
  autoload :NotIn,   'bsm/constrainable/operation/not_in'
  autoload :Between, 'bsm/constrainable/operation/between'

  register self::Eq
  register self::NotEq
  register self::In
  register self::NotIn
  register self::Gt
  register self::Lt
  register self::Gteq
  register self::Lteq
  register self::Matches
  register self::Between
end