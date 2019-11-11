# frozen_string_literal: true

require 'gosu'

class Tabuleiro
  def initialize(window, x, y)
    @tamanho_tabuleiro_linhas = x
    @tamanho_tabuleiro_colunas = y
    @matriz = Array.new(x) { Array.new(y, 0) }
    @largura_imagem = ((window.width - 200) / @tamanho_tabuleiro_colunas)
    @altura_imagem = ((window.height - 200) / @tamanho_tabuleiro_linhas)
    @navios = Array.new(5)
  end

  def show_mapa(window)
    (0..9).each do |i|
      (0..9).each do |j|
        desenhe_mar(window, i, j) if @matriz[i][j] == 0 || @matriz[i][j] == 2
        desenhe_tiro_no_mar(window, i, j) if @matriz[i][j] == 1
      end
    end
  end

  def atirar(_window, x, y)
    i = (x - 100) / @largura_imagem
    j = (y - 100) / @altura_imagem
    @matriz[i][j] = 1 if @matriz[i][j] == 0
  end

  def desenhe_mar(window, x, y)
    color = Gosu::Color::AQUA
    window.draw_rect(x * @largura_imagem + 100, y * @altura_imagem + 100, @largura_imagem, @altura_imagem, color)
  end

  def desenhe_tiro_no_mar(window, x, y)
    color = Gosu::Color::RED
    window.draw_rect(x * @largura_imagem + 100, y * @altura_imagem + 100, @largura_imagem, @altura_imagem, color)
  end
end
