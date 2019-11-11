# frozen_string_literal: true

require 'gosu'
require './tabuleiro'

class Tutorial < Gosu::Window
  def initialize
    super 640, 480
    self.caption = 'Tutorial Game'
    @tabuleiro = Tabuleiro.new(self, 10, 10)
    @tabuleiro2 = Tabuleiro.new(self, 10, 10)
  end

  def update
    # ...
  end

  def button_down(id)
    @tabuleiro.atirar(self, mouse_x, mouse_y) if id == Gosu::MsLeft
  end

  def needs_cursor?
    true
end

  def draw
    @tabuleiro.show_mapa(self)
  end
end

Tutorial.new.show
