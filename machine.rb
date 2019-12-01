# frozen_string_literal: true

require './tabuleiro'

class Machine
  def initialize; end

  def posicionar(window, tabuleiro)
    while not tabuleiro.terminou_de_posicionar
      x = rand(tabuleiro.matriz.size * tabuleiro.largura_imagem) + tabuleiro.x0
      y = rand(tabuleiro.matriz.size * tabuleiro.altura_imagem) + tabuleiro.y0
      tabuleiro.posicionar(window, x, y, [true, false].sample)
    end
  end
end
