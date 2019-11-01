require 'gosu'
require_relative "fabrica_grade"

class Tutorial < Gosu::Window
  def initialize
    super 600, 600
    self.caption = "Tutorial Game"
    @background_image = Gosu::Image.new("quadrado.png", :tileable => true)
  end
  
  def update
    # ...
  end
  
  def draw
    fg = FabricaGrade.construir_grade(10, 10)
    x = 0
    y = 0
    fg.each do |linha|
        x = 0
        linha.each do |coluna|
            @background_image.draw(x, y, 0)
            x = x + 60
        end
        y = y + 60
    end
  end
end

Tutorial.new.show