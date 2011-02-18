module Bsm::Constrainable::Field
  extend Bsm::Constrainable::Registry

  autoload :Base,     'bsm/constrainable/field/base'
  autoload :Number,   'bsm/constrainable/field/common'
  autoload :Integer,  'bsm/constrainable/field/common'
  autoload :Decimal,  'bsm/constrainable/field/common'
  autoload :String,   'bsm/constrainable/field/common'
  autoload :Timestamp,'bsm/constrainable/field/common'
  autoload :Date,     'bsm/constrainable/field/common'

  register self::Number
  register self::Integer
  register self::Decimal
  register self::String
  register self::Timestamp
  register self::Date
end