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
end
