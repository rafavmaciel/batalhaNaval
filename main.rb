# frozen_string_literal: true

require 'gosu'
require './tabuleiro'

class Tutorial < Gosu::Window
  def initialize
    super 800, 800
    self.caption = 'Tutorial Game'
    @tabuleiro = Tabuleiro.new
    @tabuleiro2 = Tabuleiro.new
    @posicionar_navio = true
  end

  def update; end

  def button_down(id)
    if id == Gosu::MsLeft
      if @atirar
        @tabuleiro.atirar(self, mouse_x, mouse_y)
      elsif @posicionar_navio
        @tabuleiro.posicionar(self, mouse_x, mouse_y)
      end
    end
  end

  def needs_cursor?
    true
  end

  def draw
    @tabuleiro.show_mapa(self)
  end
end

Tutorial.new.show
