class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    self.each_with_index.inject(0) do |acc, (el, ind)|
      (el.hash + ind.hash) ^ acc.hash
    end
  end
end

class String
  def hash
    alpha = ("a".."z").to_a
    self.each_char.with_index.inject(0) do |acc, (el, ind)|
      (alpha.index(el).hash + ind.hash) ^ acc.hash
    end
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    array_conv = self.to_a
    array_conv.sort.hash
  end
end
