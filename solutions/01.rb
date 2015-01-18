def series(type, n)
  case type
    when 'fibonacci' then generic_series(n, 1, 1)
    when 'lucas'     then generic_series(n, 2, 1)
    when 'summed'    then generic_series(n, 1, 1) + generic_series(n, 2, 1)
  end
end

def generic_series(number, first_value, second_value)
  return first_value  if number == 1
  return second_value if number == 2

  generic_series(number - 1, first_value, second_value) +
  generic_series(number - 2, first_value, second_value)
end