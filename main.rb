# frozen_string_literal: true

require 'gosu'
require './tabuleiro'

class Tutorial < Gosu::Window
  def initialize
    super 1200, 800
    self.caption = 'Tutorial Game'
    @tabuleiro1 = Tabuleiro.new([100, 100], '1')
    @tabuleiro2 = Tabuleiro.new([600, 100], '2')
    @posicionar_navio = true
    @jogador_atual = 1
    @font = Gosu::Font.new 20
  end

  def update
  end

  def mudar_a_vez
    @jogador_atual = @jogador_atual == 1 ? 2 : 1
  end

  def vencedor
    @atirar = false
    @msg = "Jogador #{@jogador_atual} venceu"
  end

  def atirar_no_tabuleiro
    if @jogador_atual == 2
      @tabuleiro1.atirar(self, mouse_x, mouse_y)
      if @tabuleiro1.errou_o_tiro?
        mudar_a_vez
      elsif @tabuleiro1.perdeu?
        vencedor
      end
    else
      @tabuleiro2.atirar(self, mouse_x, mouse_y)
      if @tabuleiro2.errou_o_tiro?
        mudar_a_vez
      elsif @tabuleiro2.perdeu?
        vencedor
      end
    end
  end

  def mudar_orientacao
    @horizontal = @horizontal ? false : true
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if @atirar
        atirar_no_tabuleiro
      elsif @posicionar_navio
        if mouse_x.between?(900, 940) && mouse_y.between?(30, 70)
          mudar_orientacao
        end
        posicionar_navios
      end
    end
  end

  def posicionar_navios
    if @jogador_atual == 1
      @tabuleiro1.posicionar(self, mouse_x, mouse_y, @horizontal)
      if @tabuleiro1.terminou_de_posicionar
        @jogador_atual = 2
      end
    else
      @tabuleiro2.posicionar(self, mouse_x, mouse_y, @horizontal)
      if @tabuleiro2.terminou_de_posicionar
        @jogador_atual = 1
        @atirar = true
        @posicionar_navio = false
      end
    end
  end

  def needs_cursor?
    true
  end

  def draw
    @tabuleiro1.show_mapa(self)
    @tabuleiro2.show_mapa(self)
    @msg = "Jogador #{@jogador_atual} faça sua jogada" if @atirar
    @msg = "Jogador #{@jogador_atual} posicione os navios" if @posicionar_navio
    @font.draw_text(@msg, 200, 50, 0)
    if @posicionar_navio
      @font.draw_text("Posicionar na horizontal?", 680, 50, 0)
      color = @horizontal ? Gosu::Color::GREEN : Gosu::Color::RED
      self.draw_rect(900, 30, 40, 40, color)
    end
  end
end

Tutorial.new.show
