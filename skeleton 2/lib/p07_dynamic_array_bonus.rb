class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  attr_accessor :count, :store
  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    if i >= 0
      return @store[i]
    elsif i < 0
      return nil if i < -length
      return self[length + i]
    end
  end

  def []=(i, val)
    if i == @count
      self.push(val)
    elsif i > @count
      (i - @count).times { push(nil) }
      self.push(val)
    elsif i < 0
      @store[@count + i] = val
    elsif i < @count
      @store[i] = val
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    self.each { |bucket| return true if bucket == val }
    false
  end

  def push(val)
    resize! if @count >= capacity
    @store[@count] = val
    @count += 1
  end

  def unshift(val)
    resize! if length == capacity
    @count += 1
    (length).downto(1).each do |i|
      self[i] = @store[i - 1]
    end
    self[0] = val
  end

  def pop
    return nil if length == 0
    last_item = self.last
    each_with_index { |val, i| self[i] = nil if val == last_item }
    @count -= 1
    last_item
  end

  def shift
    shifted = self.first
    (1...capacity).each do |si|
      @store[si - 1] = @store[si]
    end
    @count -= 1
    shifted
  end

  def first
    @store[0]
  end

  def last
    i = 1
    until @store[capacity - i]
      i += 1
    end
    return @store[capacity - i] unless nil
  end

  def each
    (0...capacity).each do |index|
      yield self[index]
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless count == other.length
    each_with_index { |el, i| return false unless other[i] == el }
    true
    # ...
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_store = StaticArray.new(capacity*2)
    each_with_index { |el, i| new_store[i] = el }
    @store = new_store
  end
end
