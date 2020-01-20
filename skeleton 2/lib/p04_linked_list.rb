class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
    @prev.next = @next
    @next.prev = @prev
  end
end

class LinkedList
  include Enumerable
  
  attr_accessor :head, :tail
  def initialize
    @head = Node.new("head")
    @tail = Node.new("tail")
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    @head.next == @tail && @tail.prev == @head
  end

  def get(key)
    # pointer = @head
    # until pointer.key == key
    #   pointer = pointer.next
    #   return nil if pointer == nil
    # end
    # pointer.val
    self.each do |k|
      return k.val if key == k.key
    end
    nil
  end

  def include?(key)
    self.any? { |k| k.key == key }
  end

  def append(key, val)
    new_node = Node.new(key, val)
    @tail.prev.next = new_node
    new_node.prev = @tail.prev
    new_node.next = @tail
    @tail.prev = new_node

    new_node
  end

  def update(key, val)
    self.each do |k|
      return k.val = val if key == k.key
    end
    nil
  end

  def remove(key)
    pointer = @head
    until pointer.key == key
      return nil if pointer == nil
      pointer = pointer.next
    end
    pointer.remove
  end

  def each
    pointer = @head.next
    until pointer.next == nil
      yield pointer
      pointer = pointer.next
    end
  end

  #uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
