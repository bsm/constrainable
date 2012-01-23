module Bsm::Constrainable::Field
  class Number < Base
    self.operators += [:in, :not_in]

    protected

    def _convert(v)
      Float(v) rescue nil
    end
  end

  class Integer < Number
    protected

    def _convert(v)
      result = super
      result ? result.to_i : nil
    end
  end

  class Decimal < Number
  end

  class String < Base
    self.operators = [:eq, :not_eq]

    def _convert(v)
      result = super
      result.blank? && !options[:allow_blank] ? nil : result
    end
  end

  class Timestamp < Base
    protected

    def _convert(v)
      v.to_time(:utc) rescue nil
    end
  end

  class Datetime < Timestamp
  end

  class Date < Base
    protected

    def _convert(v)
      v.to_date rescue nil
    end
  end

  class Boolean < Base
    self.operators = [:eq, :not_eq]

    TRUE_VALUES = ["true", "TRUE", "t", "T", "1", 1].to_set.freeze
    FALSE_VALUES = ["false", "FALSE", "f", "F", "0", 0].to_set.freeze

    protected

    def _convert(v)
      result = super
      TRUE_VALUES.include?(result) || (FALSE_VALUES.include?(result) ? false : nil)
    end
  end

end
