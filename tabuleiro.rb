# frozen_string_literal: true

require 'gosu'
require './navio'

class Tabuleiro
  def initialize(window, a)
    @x0 = 146
    @y0 = 226
    @matriz = Array.new(10) { Array.new(10, 0) }
    @largura_imagem = 40
    @altura_imagem = 40
    @navios = Array.new(5)
    @imagem = Gosu::Image.new('imagens/tabuleiro-1.png')
    @tiro_na_agua = Gosu::Image.new('imagens/errou.png')
    @tiro_no_navio = Gosu::Image.new('imagens/acertou.png')
  end

  def show_mapa(window)
    @imagem.draw(100, 100, 0)
    (0..9).each do |i|
      (0..9).each do |j|
        case @matriz[i][j]
        when 1
          desenhe_tiro_no_mar(window, i, j)
        when 2
          desenhe_navio(window, i, j)
        end
      end
    end
  end

  def atirar(_window, x, y)
    i = (x - @x0) / @largura_imagem
    j = (y - @y0) / @altura_imagem
    @matriz[i][j] = 1 if @matriz[i][j] == 0
    @matriz[i][j] = 3 if @matriz[i][j] == 2
  end


  def posicionar(_window, x, y)
    i = (x - @x0) / @largura_imagem
    j = (y - @y0) / @altura_imagem
    @navios[0] = Navio.new(2,[i,j], true)
    @navios[0].posicoes.each do |posicao|
      @matriz[posicao[0]][posicao[1]] = 2
    end
  end

  def desenhe_navio(window, x, y)
    color = Gosu::Color::YELLOW
    window.draw_rect(x * @largura_imagem + @x0, y * @altura_imagem + @y0, @largura_imagem, @altura_imagem, color)
  end

  def desenhe_tiro_no_mar(window, x, y)
    color = Gosu::Color::RED
    @tiro_na_agua.draw(x * @largura_imagem + @x0, y * @altura_imagem + @y0, 0)
  end
end
