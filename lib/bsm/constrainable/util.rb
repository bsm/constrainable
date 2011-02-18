module Bsm::Constrainable::Util # :nodoc:
  extend self

  def normalized_hash(hash)
    hash.is_a?(Hash) ? hash.stringify_keys : {}
  end

  def normalized_array(array)
    array = array.keys if array.is_a?(Hash)
    Array.wrap(array).map do |item|
      item.to_s.split('|')
    end.flatten.reject(&:blank?).uniq
  end

end