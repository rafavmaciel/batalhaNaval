# frozen_string_literal: true

class Navio
  attr_accessor :tamanho, :posicao, :posicoes, :segmentos_destruidos,
                :horizontal, :imagens, :posicionado

  def initialize(tamanho)
    @tamanho = tamanho
    @imagens = Array.new(tamanho)
    carregar_imagens
  end

  def carregar_imagens
    caminho = case @tamanho
              when 6
                'imagens/porta-avioes/'
              when 4
                'imagens/guerra/'
              when 3
                'imagens/encouracado/'
              when 1
                'imagens/submarino/'
              else
                ''
              end
    (0..@tamanho - 1).each do |k|
      @imagens[k] = Gosu::Image.new(caminho + "#{k}.png")
    end
  end

  def posicionar(posicao, horizontal)
    @posicionado = true
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
