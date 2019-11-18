# frozen_string_literal: true

require 'gosu'
require './navio'

class Tabuleiro
  def initialize
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
    (0..9).each do |linha|
      (0..9).each do |coluna|
        case @matriz[linha][coluna]
        when 1
          desenhe_tiro_no_mar(linha, coluna)
        when 2
          desenhe_navio(window, linha, coluna)
        end
      end
    end
  end

  def clicou_no_tabuleiro(mouse_x, mouse_y)
    mouse_x > @x0 && mouse_y > @y0 && mouse_x < @matriz.size * @largura_imagem + @x0 && mouse_y < @matriz.size * @altura_imagem + @y0
  end

  def atirar(_window, mouse_x, mouse_y)
    if clicou_no_tabuleiro(mouse_x, mouse_y) && posicao_valida_para_atirar(mouse_x, mouse_y)
      print 'pey'
      linha = (mouse_y - @y0) / @altura_imagem
      coluna = (mouse_x - @x0) / @largura_imagem
      @matriz[linha][coluna] = 1 if @matriz[linha][coluna] == 0
      @matriz[linha][coluna] = 3 if @matriz[linha][coluna] == 2
    end
  end

  def posicao_valida_para_posicionar(mouse_x, mouse_y)
    linha = (mouse_y - @y0) / @altura_imagem
    coluna = (mouse_x - @x0) / @largura_imagem
    # if true
    (0..1).each do |k|
      if coluna.to_i + k > @matriz.size - 1 || @matriz[linha][coluna + k] != 0
        return false
      end
    end
    # else
    #   (0..navio_atual.tamanho).each do |k|
    #     return false if i + k > @matriz.size || @matriz[i + k][j] != 0
    #   end
    # end
  end

  def posicao_valida_para_atirar(mouse_x, mouse_y)
    linha = (mouse_y - @y0) / @altura_imagem
    coluna = (mouse_x - @x0) / @largura_imagem
    @matriz[linha][coluna] == 0
  end

  def posicionar(_window, mouse_x, mouse_y)
    if clicou_no_tabuleiro(mouse_x, mouse_y) && posicao_valida_para_posicionar(mouse_x, mouse_y)
      linha = (mouse_y - @y0) / @altura_imagem
      coluna = (mouse_x - @x0) / @largura_imagem
      @navios[0] = Navio.new(2, [linha, coluna], true)
      @navios[0].posicoes.each do |posicao|
        @matriz[posicao[0]][posicao[1]] = 2
      end
    end
  end

  def desenhe_navio(window, linha, coluna)
    color = Gosu::Color::YELLOW
    window.draw_rect(coluna * @altura_imagem + @x0, linha * @largura_imagem + @y0, @largura_imagem, @altura_imagem, color)
  end

  def desenhe_tiro_no_mar(linha, coluna)
    @tiro_na_agua.draw(coluna * @altura_imagem + @x0, linha * @largura_imagem + @y0, 0)
  end
end
