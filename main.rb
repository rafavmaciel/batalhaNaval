# frozen_string_literal: true

require 'gosu'
require './tabuleiro'

class Tutorial < Gosu::Window
  def initialize
    super 800, 800
    self.caption = 'Tutorial Game'
    @tabuleiro1 = Tabuleiro.new
    @tabuleiro2 = Tabuleiro.new
    @posicionar_navio = true
    @jogador_atual = 1
  end

  def update; end

  def mudar_a_vez
    @jogador_atual = @jogador_atual == 1 ? 2 : 1
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if @atirar
        @tabuleiro1.atirar(self, mouse_x, mouse_y)
        if @tabuleiro1.errou_o_tiro?
          mudar_a_vez
        end
        puts @tabuleiro1.errou_o_tiro?
      elsif @posicionar_navio
        @tabuleiro1.posicionar(self, mouse_x, mouse_y)
        if @tabuleiro1.terminou_de_posicionar
          @posicionar_navio = false
          @atirar = true
        end
      end
    end
  end

  def needs_cursor?
    true
  end

  def draw
    @tabuleiro1.show_mapa(self)
  end
end

Tutorial.new.show
