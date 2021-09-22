require 'matrix'

class Matrix_ < Matrix
  include ConversionHelper

  def to_s
    if empty?
      return "[]"
    end
    string = ''
    (0...row_count).each do |i|
      string += @rows[i].to_s + "\n"
    end
    string
  end

  def resize
    @rows.each do |i|
      i.fill(0, i.size, @column_count - i.size)
    end
  end
  private :resize

  def add_row(row)
    convert_to_array row
    if row.size < @column_count
      row.fill(0, row.size, @column_count - row.size)
    elsif row.size > @column_count
      @column_count = row.size
      resize
    end
    @rows << row
  end

  def each_row(which = :def ,&block)
    case which
    when :def
      @rows.each(&block)
    when :index
      @rows.each_with_index(&block)
    else
      raise ArgumentError
    end
  end

  def reverse_each_row(which = :def ,&block)
    case which
    when :def
      @rows.reverse_each(&block)
    when :index
      @rows.to_enum.with_index.reverse_each(&block)
    else
      raise ArgumentError
    end
  end

  def swap_rows(i, j)
    @rows[i], @rows[j] = @rows[j], rows[i]
  end
end

def input_number_row(m)
  begin
    nums = gets.split(" ")
    if nums.length != m
      raise ArgumentError.new "Invalid count of elements!!!"
    end
    nums.map! do |x|
      Float x
    end
  rescue Exception => e
    puts e.message
    puts "Try again!"
    return input_number_row(m)
  end
  nums
end

def fill_matrix(n, m, matrix)
  (0...n).each do |i|
    puts "Please input #{m} numbers for row #{i+1} separated by " ""
    row = input_number_row(m)
    matrix.add_row(row)
  end
end

def input_int_upper_zero(message)
  print(message)
  n = gets
  begin
    n = n.to_i
    if n <= 0
      raise TypeError
    end
  rescue TypeError
    puts("You've entered invalid value!!!")
    return input_int_upper_zero(message)
  end
  n
end