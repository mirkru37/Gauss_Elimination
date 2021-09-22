load 'Matrix_.rb'


def l_u_decompose(l, u, m)
  n = m.row_count
  (0...n).each do |i|
    (i...n).each do |k|
      sum = 0
      (0...i).each do |j|
        sum += l[i, j] * u[j, k]
      end
      u[i, k] = m[i,k]-sum
      if i == k
        l[i, i] = 1
      else
        sum = 0
        (0...i).each do |j|
          sum += l[k, j] * u[j, i]
        end
        l[k, i] = (m[k, i] - sum) / u[i, i]
      end
    end
  end
end

#n = input_int_upper_zero("Input N: ")
#m = Matrix_.empty
n = 3
m = Matrix_.rows([
                   [-3, 3, -3],
                   [-3, 7, -7],
                   [6, 6, -9]
                 ])
#fill_matrix(n, n, m)
puts "Your matrix: ", m
l = Matrix_.zero(n)
u = Matrix_.zero(n)
l_u_decompose(l, u, m)
puts "L:", l, "U:", u
puts "L*U", l*u