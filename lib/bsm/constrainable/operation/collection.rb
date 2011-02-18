module Bsm::Constrainable::Operation
  class Collection < Base

    def parsed
      Bsm::Constrainable::Util.normalized_array(value)
    end

  end
end
