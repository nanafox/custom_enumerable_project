# frozen_string_literal: true

module Enumerable
  def my_count(&block)
    return length unless block_given?

    total_count = 0

    for item in self
      total_count += 1 if block.call(item)
    end

    total_count
  end

  def my_each_with_index
    return unless block_given?

    index = 0

    for item in self
      yield item, index
      index += 1
    end
  end

  def my_all?
    if block_given?
      for item in self
        return false unless yield item
      end
    else
      for item in self
        return false unless item
      end
    end
    true
  end

  def my_any?
    if block_given?
      for item in self
        return true if yield item
      end
    else
      for item in self
        return true if item
      end
    end
    false
  end

  def my_none?
    if block_given?
      my_all? { |item| !yield item }
    else
      my_all?(&:!)
    end
  end

  def my_inject(initial_operand = nil, symbol = nil)
    if initial_operand.nil? && symbol.nil?
      accumulator = first
      drop(1).my_each { |element| accumulator = yield(accumulator, element) }
    elsif initial_operand && symbol.nil? && initial_operand.is_a?(Symbol)
      symbol = initial_operand
      accumulator = first
      drop(1).my_each { |element| accumulator = accumulator.send(symbol, element) }
    elsif initial_operand && symbol.nil?
      accumulator = initial_operand
      my_each { |element| accumulator = yield(accumulator, element) }
    else
      accumulator = initial_operand
      my_each { |element| accumulator = accumulator.send(symbol, element) }
    end
    accumulator
  end

  def my_map
    new_array = []
    my_each { |item| new_array << yield(item) } if block_given?
    new_array
  end

  def my_select(&block)
    new_array = []

    my_each { |item| new_array << item if block.call(item) }

    new_array
  end
end

# Array class
class Array
  # Iterates over items in an object
  def my_each
    for item in self
      yield item
    end
  end
end
