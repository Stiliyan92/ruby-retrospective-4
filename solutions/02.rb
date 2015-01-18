class NumberSet
  include Enumerable

  def initialize
    @number_set = []
  end

  def <<( number )
    unless @number_set.include? number
      @number_set << number
    end
  end

  def each
    @number_set.each { |x| yield x }
  end

  def size
    @number_set.length
  end

  def empty?
    @number_set.empty?
  end

  def []( filter )
    p filter.filter_set_of_numbers @number_set
  end
end

class SignFilter
  def initialize number_sign_type
    @sign = number_sign_type
  end

  def filter_set_of_numbers numbers
    case @sign.to_s
      when "negative"
        numbers.select { |x| x.real < 0.0 }
      when "positive"
        numbers.select { |x| x.real > 0.0 }
      when "non_positive"
        numbers.select { |x| x.real <= 0.0 }
      else
        numbers.select { |x| x.real >= 0.0 }
    end
  end
end

class TypeFilter
  def initialize number_type
    @number_type = number_type
  end

  def filter_set_of_numbers numbers
    case @number_type.to_s
      when "complex"
        numbers.select { |x| x.class.to_s == "Complex" }
      when "real", "rational"
        real_and_rational = numbers.select { |x| x.class.to_s == "Float" }
        real_and_rational + numbers.select { |x| x.class.to_s == "Rational" }
      when "integer"
        numbers.select { |x| x.class.to_s == "Fixnum" }
    end
  end
end

class Filter
  def initialize &block
    @filter = block
  end

  def filter_set_of_numbers numbers
    numbers.select { |x| @filter.call x.real.round }
  end
end

numbers = NumberSet.new
numbers << 2.0
numbers << 4+0i
numbers << -3
numbers << Rational(14, 3)
numbers << Rational(-23, 2)
numbers << -4.0
numbers << 2
numbers << -1+3i
numbers << 0.0
p numbers

numbers[SignFilter.new(:non_negative)]
numbers[Filter.new { |number| number.even? }]
numbers[TypeFilter.new(:complex)]