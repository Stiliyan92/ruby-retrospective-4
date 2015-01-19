class NumberSet
  include Enumerable

  def initialize(initial_numbers = [])
    @number_set = initial_numbers
  end

  def <<(number)
    @number_set << number unless @number_set.include? number
  end

  def each (&block)
    @number_set.each &block
  end

  def size
    @number_set.length
  end

  def empty?
    @number_set.empty?
  end

  def [](filter)
    NumberSet.new @number_set.select {|number| filter.matches? number}
  end
end


class Filter

  def initialize(&block)
    @filter = block
  end

  def matches?(number)
    @filter.call number
  end

  def &(other_filter)
    Filter.new { |number| matches? number and other_filter.matches? number }
  end

  def |(other_filter)
    Filter.new { |number| matches? number or other_filter.matches? number }
  end

end


class TypeFilter < Filter

  def initialize(number_type)
    case number_type
      when :integer then super() { |n| n.is_a? Integer }
      when :real    then super() { |n| n.is_a? Float or n.is_a? Rational }
      when :complex then super() { |n| n.is_a? Complex }
    end
  end

end

class SignFilter < Filter

  def initialize(sign)
    case sign
      when :positive     then super() { |number| number > 0 }
      when :negative     then super() { |number| number < 0 }
      when :non_positive then super() { |number| number <= 0 }
      when :non_negative then super() { |number| number >= 0 }
    end
  end

end