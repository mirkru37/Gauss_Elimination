load 'Matrix_.rb'

UNDEF_X = "undef"

def fancy_print_system_equation (matrix)
  if matrix.class != (Matrix and Matrix_)
    raise TypeError
  end
  puts "=Begin"
  matrix.each_row do |row|
    print "\t"
    row.each_index do |i|
      if i == row.size - 1
        puts " = #{row[i]}"
      else
        print "#{row[i] >= 0 && i != 0?'+':''}#{row[i]}x#{i+1}"
      end
    end
  end
  puts "=End"
end

def do_stairs(matrix)
  def make_row_zero(row ,matrix ,i, j)
    if matrix[j, i] != 0
      mult = Rational(matrix[j, i], matrix[i, i])
      row.map!.with_index do |x, k|
        x - matrix[i, k] * mult
      end
    end
  end
  (0...matrix.column_count-1).each do |i|
    matrix.each_row(:index) do |row ,j|
      if i < j
        begin
          make_row_zero(row, matrix ,i, j)
        rescue ZeroDivisionError
          matrix.swap_rows(i, j)
          make_row_zero(row, matrix ,i, j)
        end
      end
    end
  end
  matrix
end

def convert_rational_to_num(result)
  result.map! do |x|
    if x.class == Rational
      if x.denominator == 1
        next x.to_i
      elsif x.to_f.to_s.split('.').last.size <= 2
        next x.to_f
      end
    end
    x
  end
end

def dirty_gausse(matrix)
  result = []
  adds = []
  do_stairs(matrix)
  matrix.reverse_each_row(:index) do |row, i|
    result[i] = row[-1]
    (matrix.column_count - 2).downto(i+1).each do |j|
      if result[j] != UNDEF_X
        result[i] -= row[j]*result[j]
      else
        adds[i] = -1 * Rational(row[j], row[i])
      end
      unless adds[j].nil?
        adds[i] = adds[i] ? adds[i] + adds[j] : adds[j]
      end
    end
    begin
      result[i] = Rational(result[i],row[i])
    rescue Exception => e
      if e.class == ZeroDivisionError
        if result[i] != 0
          puts matrix
          raise ArgumentError(puts "Wrong parameters in equation 0*x#{i+1} != #{result[i]}")
        end
      end
      result[i] = UNDEF_X
    end
  end
  convert_rational_to_num(result)
  convert_rational_to_num(adds)
  adds << result.map.with_index { |x, i|
    if x == UNDEF_X
       "x#{i+1}"
    end
  }.reject! {|x| x.nil?}.join
  result << adds
end

def fancy_print_result(x)
  adds = x[-1]
  undef_x = adds[-1]
  adds.pop
  x.pop
  x.each_with_index do |el, i|
    print "x#{i+1} = #{el}"
    unless adds[i].nil?
      print adds[i] >= 0?" + ":'', adds[i], undef_x
    end
    puts
  end
end


m = Matrix_.empty
=begin
n = input_int_upper_zero("Enter x count: ")
fill_matrix(n, n+1, m)
=end
m.add_row([5.0, -3.0, 2.0, -8.0, 1.0])
m.add_row([1, 1, 1, 1, 0])
m.add_row([3, 5, 1, 4, 0])
m.add_row([4, 2, 3, 1, 3])

fancy_print_system_equation m
x = dirty_gausse m.clone
fancy_print_result(x)
