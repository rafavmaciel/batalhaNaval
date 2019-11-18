# frozen_string_literal: true

class Navio
  attr_accessor :tamanho, :posicao, :posicoes, :segmentos_destruidos, :horizontal
  def initialize(tamanho, posicao, horizontal)
    raise 'Argumento tamanho eh invalido!' if tamanho < 1

    @tamanho = tamanho
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
end
