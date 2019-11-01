require_relative 'quadrante'

class FabricaGrade
  def self.construir_grade(x,y)
    grade = Array.new x
    grade.each_index do |x_index|
      grade[x_index] = Array.new y
      grade.each_index do |y_index|
        grade[x_index][y_index] = Quadrante.new
      end
    end
    return grade
  end
end
