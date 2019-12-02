# frozen_string_literal: true

require 'gosu'
require './navio'

class Tabuleiro
  attr_accessor :mostrar_navios
  attr_reader :x0, :y0, :largura_imagem, :altura_imagem, :matriz, :navios, :acertou

  def initialize(posicao, numero)
    @x0 = posicao[0] + 46
    @y0 = posicao[1] + 126
    @matriz = Array.new(10) { Array.new(10, 0) }
    @largura_imagem = @altura_imagem = 40
    @navios = [Navio.new(6), Navio.new(4), Navio.new(3), Navio.new(3),
               Navio.new(1)]
    @navios_posicionados = 0
    @imagem = Gosu::Image.new("imagens/tabuleiro-#{numero}.png")
    @tiro_na_agua = Gosu::Image.new('imagens/errou.png')
    @tiro_no_navio = Gosu::Image.new('imagens/acertou.png')
    @mostrar_navios = true
    @errou = false
    @posicao = posicao
  end

  def show_para_posicionar(_window)
    @imagem.draw(@posicao[0], @posicao[1], 0)
    @navios.each do |navio|
      desenhe_navio(navio) if navio.posicionado
    end
  end

  def show_para_atirar(_window)
    @imagem.draw(@posicao[0], @posicao[1], 0)
    @navios.each do |navio|
      if navio.posicionado && navio.esta_destruido?
        desenhe_navio_destruido(navio)
      end
    end
    (0..9).each do |linha|
      (0..9).each do |coluna|
        case @matriz[linha][coluna]
        when 1
          desenhe_tiro_no_mar(linha, coluna)
        when 3
          desenhe_tiro_no_navio(linha, coluna)
        end
      end
    end
  end

  def errou_o_tiro?
    @errou
  end

  def show_mapa(window)
    show_para_atirar(window)
    show_para_posicionar(window) if @mostrar_navios
  end

  def clicou_no_tabuleiro(mouse_x, mouse_y)
    mouse_x > @x0 && mouse_y > @y0 && mouse_x < @matriz.size * @largura_imagem + @x0 && mouse_y < @matriz.size * @altura_imagem + @y0
  end

  def atirar(mouse_x, mouse_y)
    @errou = true
    @acertou = false
    if clicou_no_tabuleiro(mouse_x, mouse_y) && posicao_valida_para_atirar(mouse_x, mouse_y)
      linha = pegar_linha(mouse_y)
      coluna = pegar_coluna(mouse_x)
      @navios.each do |navio|
        if navio.destruir_segmento(linha, coluna)
          @matriz[linha][coluna] = 3 if @matriz[linha][coluna] == 2
          @errou = false
          @acertou = true
        elsif @matriz[linha][coluna].zero?
          @matriz[linha][coluna] = 1
        end
        next unless navio.esta_destruido?

        navio.posicoes.each do |posicao|
          @matriz[posicao[0]][posicao[1]] = 4
        end
        perdeu?
      end
    else
      @errou = false
    end
  end

  def atirar_usando_linha_coluna(linha, coluna)
    x = coluna * @altura_imagem + @x0
    y = linha * @largura_imagem + @y0
    atirar(x, y)
  end

  def perdeu?
    perdeu = true
    @navios.each do |navio|
      perdeu = false unless navio.esta_destruido?
    end
    perdeu
  end

  def posicao_valida_para_posicionar(mouse_x, mouse_y, navio, horizontal)
    linha = pegar_linha(mouse_y)
    coluna = pegar_coluna(mouse_x)
    (0..(navio.tamanho - 1)).each do |k|
      puts "#{k}, #{linha}, #{coluna}, #{linha + k}, #{coluna + k}, #{@matriz.size}"
      if horizontal
        if coluna + k >= @matriz.size || @matriz[linha][coluna + k] != 0
          return false
        end
      elsif linha + k >= @matriz.size || @matriz[linha + k][coluna] != 0
        return false
      end
    end
    true
  end

  def posicao_valida_para_atirar(mouse_x, mouse_y)
    linha = pegar_linha(mouse_y)
    coluna = pegar_coluna(mouse_x)
    @matriz[linha][coluna].zero? || (@matriz[linha][coluna] == 2)
  end

  def posicionar(mouse_x, mouse_y, horizontal)
    if clicou_no_tabuleiro(mouse_x, mouse_y) && posicao_valida_para_posicionar(mouse_x, mouse_y, @navios[@navios_posicionados], horizontal)
      linha = pegar_linha(mouse_y)
      coluna = pegar_coluna(mouse_x)
      navio = @navios[@navios_posicionados]
      @navios_posicionados += 1
      navio.posicionar([linha, coluna], horizontal)
      navio.posicoes.each do |posicao|
        @matriz[posicao[0]][posicao[1]] = 2
        @mostrar_navios = false if terminou_de_posicionar
      end
    end
  end

  def pegar_linha(mouse_y)
    ((mouse_y - @y0) / @altura_imagem).to_i
  end

  def pegar_coluna(mouse_x)
    ((mouse_x - @x0) / @largura_imagem).to_i
  end

  def desenhe_navio(navio)
    navio.imagens.each_with_index do |imagem, index|
      y = navio.posicoes[index][0] * @altura_imagem + @y0
      x = navio.posicoes[index][1] * @largura_imagem + @x0
      if navio.horizontal
        imagem.draw(x, y, 0)
      else
        imagem.draw_rot(x + 20, y + 20, 0, 90)
      end
    end
  end

  def desenhe_tiro_no_mar(linha, coluna)
    @tiro_na_agua.draw(coluna * @altura_imagem + @x0, linha * @largura_imagem + @y0, 0)
  end

  def desenhe_tiro_no_navio(linha, coluna)
    @tiro_no_navio.draw(coluna * @altura_imagem + @x0, linha * @largura_imagem + @y0, 50)
  end

  def desenhe_navio_destruido(navio)
    navio.imagens.each_with_index do |imagem, index|
      y = navio.posicoes[index][0] * @altura_imagem + @y0
      x = navio.posicoes[index][1] * @largura_imagem + @x0
      if navio.horizontal
        imagem.draw(x, y, 0)
      else
        imagem.draw_rot(x + 20, y + 20, 0, 90)
      end
      desenhe_tiro_no_navio(navio.posicoes[index][0], navio.posicoes[index][1])
    end
  end

  def terminou_de_posicionar
    @navios_posicionados == @navios.size
  end
end
