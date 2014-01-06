class Array
  def to_hash_by_key(key)
    Hash[self.map { |r| [r[key], r] }]
  end
end