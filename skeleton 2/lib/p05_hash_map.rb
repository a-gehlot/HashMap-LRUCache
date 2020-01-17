require_relative 'p04_linked_list'

class HashMap
  include Enumerable

  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    if include?(key)
      bucket(key).update(key,val)
      return
    end
    bucket(key).append(key,val)
    @count += 1
    resize! if @count > num_buckets
  end

  def get(key)
    bucket(key).each { |k| return k.val if k.key == key }
  end

  def delete(key)
    if include?(key)
      bucket(key).remove(key)
      @count -=1
    end
  end

  def each
    pairs = []
    @store.each do |ll|
      ll.each do |k|
        yield [k.key, k.val]
      end
    end
  end

  # uncomment when you have Enumerable included
  # def to_s
  #   pairs = inject([]) do |strs, (k, v)|
  #     strs << "#{k.to_s} => #{v.to_s}"
  #   end
  #   "{\n" + pairs.join(",\n") + "\n}"
  # end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    cached = []
    self.each { |k| cached << k}
    @store = Array.new(num_buckets*2) { LinkedList.new }
    @count = 0
    cached.each { |key, val| set(key, val) }
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    @store[key.hash % num_buckets]
  end
end
