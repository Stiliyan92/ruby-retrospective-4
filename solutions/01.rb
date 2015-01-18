def fibonacci(number)
  if number <= 2 then 1
  else
    fibonacci(number - 1) + fibonacci(number - 2)
  end
end

def lucas(number)
  case number
  when 1 then 2
  when 2 then 1
  else lucas(number - 1) + lucas(number - 2)
  end
end

def call_appropriate_method(name_of_sequence,number)
  if name_of_sequence == 'lucas'
    lucas(number)
  elsif name_of_sequence == 'fibonacci'
    fibonacci(number)
  end
end

def series(name_of_sequence, number)
  if name_of_sequence == 'summed'
    fibonacci(number) + lucas(number)
  else
    call_appropriate_method(name_of_sequence, number)
  end
end
