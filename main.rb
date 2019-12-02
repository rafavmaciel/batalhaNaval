# frozen_string_literal: true

require 'gosu'
require './tabuleiro'
require './machine'

class Tutorial < Gosu::Window
  def initialize
    super 1200, 800, true
    self.caption = 'Tutorial Game'
    @tabuleiro1 = Tabuleiro.new([100, 100], '1')
    @tabuleiro2 = Tabuleiro.new([600, 100], '2')
    @intro = Gosu::Image.new('imagens/intro.png')
    @jogador_atual = 1
    @machine = Machine.new(self, @tabuleiro2)
    @font = Gosu::Font.new 20
    @selecionar_modo = true
  end

  def mudar_a_vez
    @jogador_atual = if @modo_de_jogo == 'X1'
                       @jogador_atual == 1 ? 2 : 1
                     else
                       @jogador_atual == 1 ? 3 : 1
                     end
  end

  def vencedor
    @atirar = false
    @msg = if @jogador_atual == 3
             'A maquina venceu'
           else
             "Jogador #{@jogador_atual} venceu"
           end
  end

  def atirar_no_tabuleiro
    if @jogador_atual == 1
      @tabuleiro2.atirar(mouse_x, mouse_y)
      if @tabuleiro2.errou_o_tiro?
        mudar_a_vez
      elsif @tabuleiro2.perdeu?
        vencedor
      end
    elsif @modo_de_jogo == 'X1'
      @tabuleiro1.atirar(mouse_x, mouse_y)
      if @tabuleiro1.errou_o_tiro?
        mudar_a_vez
      elsif @tabuleiro1.perdeu?
        vencedor
      end
    end
  end

  def mudar_orientacao
    @horizontal = @horizontal ? false : true
  end

  def selecionar_modo_de_jogo
    if mouse_x.between?(513, 623) && mouse_y.between?(330, 450)
      @modo_de_jogo = 'maquina'
      @jogar = true
      @posicionar_navio = true
    elsif mouse_x.between?(513, 623) && mouse_y.between?(550, 670)
      @modo_de_jogo = 'X1'
      @jogar = true
      @posicionar_navio = true
    end
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
      elsif @selecionar_modo
        selecionar_modo_de_jogo
      end
    elsif id == Gosu::KB_ESCAPE
      close
    end
  end

  def posicionar_navios
    if @jogador_atual == 1
      @tabuleiro1.posicionar(mouse_x, mouse_y, @horizontal)
      mudar_a_vez if @tabuleiro1.terminou_de_posicionar
    elsif @modo_de_jogo == 'X1'
      @tabuleiro2.posicionar(mouse_x, mouse_y, @horizontal)
      if @tabuleiro2.terminou_de_posicionar
        mudar_a_vez
        @atirar = true
        @posicionar_navio = false
      end
    end
  end

  def needs_cursor?
    true
  end

  def posicionar_automaticamente
    @machine.posicionar
    @tabuleiro1.mostrar_navios = true
    @atirar = true
    @posicionar_navio = false
    mudar_a_vez
    @machine = Machine.new(self, @tabuleiro1)
  end

  def atirar_automaticamente
    @machine.atirar
  end

  def draw
    if @jogar
      @tabuleiro1.show_mapa(self)
      @tabuleiro2.show_mapa(self)
      @msg = "Jogador #{@jogador_atual} faça sua jogada" if @atirar
      if @posicionar_navio
        @msg = "Jogador #{@jogador_atual} posicione os navios"
        @font.draw_text('Posicionar na horizontal?', 680, 50, 0)
        color = @horizontal ? Gosu::Color::GREEN : Gosu::Color::RED
        draw_rect(900, 30, 40, 40, color)
        if @modo_de_jogo == 'maquina' && @jogador_atual == 3
          posicionar_automaticamente
        end
      elsif @atirar && (@jogador_atual == 3)
        atirar_automaticamente
      end
      @font.draw_text(@msg, 200, 50, 0)
    else
      @intro.draw(0, 0, 0)
    end
  end
end

Tutorial.new.show
