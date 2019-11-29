# frozen_string_literal: true

class Navio
  attr_accessor :tamanho, :posicao, :posicoes, :segmentos_destruidos, :horizontal
  def initialize(tamanho)
    @tamanho = tamanho
  end

  def posicionar(posicao, horizontal)
    @posicao = posicao
    @horizontal = horizontal
    @segmentos_destruidos = Array.new(@tamanho, false)
    @posicoes = Array.new(@tamanho)
    @posicoes[0] = posicao
    if horizontal
      (1...@tamanho).each do |n|
        @posicoes[n] = [posicao[0], posicao[1] + n]
      end
    else
      (1...@tamanho).each do |n|
        @posicoes[n] = [posicao[0] + n, posicao[1]]
      end
    end
  end

  def destruir_segmento(linha, coluna)
    destruiu = false
    if @posicoes.include?([linha, coluna])
      destruiu = true
      if @horizontal
        @segmentos_destruidos[@posicao[1] - coluna] = true
      else
        @segmentos_destruidos[@posicao[0] - linha] = true
      end
    end
    destruiu
  end

  def esta_destruido?
    @segmentos_destruidos.all?
  end
end
