# frozen_string_literal: true

require 'gosu'
require './navio'

class Tabuleiro
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

  def show_para_posicionar(window)
    @imagem.draw(@posicao[0], @posicao[1], 0)
    (0..9).each do |linha|
      (0..9).each do |coluna|
        case @matriz[linha][coluna]
        when 2
          desenhe_navio(window, linha, coluna)
        end
      end
    end
  end

  def show_para_atirar(window)
    @imagem.draw(@posicao[0], @posicao[1], 0)
    (0..9).each do |linha|
      (0..9).each do |coluna|
        case @matriz[linha][coluna]
        when 1
          desenhe_tiro_no_mar(linha, coluna)
        when 3
          desenhe_navio(window, linha, coluna)
          desenhe_tiro_no_navio(linha, coluna)
        when 4
          desenhe_navio_destruido(window, linha, coluna)
        end
      end
    end
  end

  def errou_o_tiro?
    @errou
  end

  def show_mapa(window)
    if @mostrar_navios
      show_para_posicionar(window)
    else
      show_para_atirar(window)
    end
  end

  def clicou_no_tabuleiro(mouse_x, mouse_y)
    mouse_x > @x0 && mouse_y > @y0 && mouse_x < @matriz.size * @largura_imagem + @x0 && mouse_y < @matriz.size * @altura_imagem + @y0
  end

  def atirar(_window, mouse_x, mouse_y)
    @errou = true
    if clicou_no_tabuleiro(mouse_x, mouse_y) && posicao_valida_para_atirar(mouse_x, mouse_y)
      linha = pegar_linha(mouse_y)
      coluna = pegar_coluna(mouse_x)
      @navios.each do |navio|
        if navio.destruir_segmento(linha, coluna)
          @matriz[linha][coluna] = 3 if @matriz[linha][coluna] == 2
          @errou = false
        else
          @matriz[linha][coluna] = 1 if @matriz[linha][coluna].zero?
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
    testar_direita(_window,linha, coluna)
  end

  def perdeu?
    perdeu = true
    @navios.each do |navio|
      perdeu = false unless navio.esta_destruido?
    end
    perdeu
  end

  def posicao_valida_para_posicionar(mouse_x, mouse_y, navio)
    linha = pegar_linha(mouse_y)
    coluna = pegar_coluna(mouse_x)
    (0..(navio.tamanho - 1)).each do |k|
      if coluna.to_i + k > @matriz.size || @matriz[linha][coluna + k] != 0
        return false
      end
    end
  end

  def posicao_valida_para_atirar(mouse_x, mouse_y)
    linha = pegar_linha(mouse_y)
    coluna = pegar_coluna(mouse_x)
    @matriz[linha][coluna].zero? || (@matriz[linha][coluna] == 2)
  end

  def posicionar(_window, mouse_x, mouse_y)
    if clicou_no_tabuleiro(mouse_x, mouse_y) && posicao_valida_para_posicionar(mouse_x, mouse_y, @navios[@navios_posicionados])
      linha = pegar_linha(mouse_y)
      coluna = pegar_coluna(mouse_x)
      navio = @navios[@navios_posicionados]
      @navios_posicionados += 1
      navio.posicionar([linha, coluna], true)
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

  def desenhe_navio(window, linha, coluna)
    color = Gosu::Color::YELLOW
    window.draw_rect(coluna * @altura_imagem + @x0, linha * @largura_imagem + @y0, @largura_imagem, @altura_imagem, color)
  end

  def desenhe_tiro_no_mar(linha, coluna)
    @tiro_na_agua.draw(coluna * @altura_imagem + @x0, linha * @largura_imagem + @y0, 0)
  end

  def desenhe_tiro_no_navio(linha, coluna)
    @tiro_no_navio.draw(coluna * @altura_imagem + @x0, linha * @largura_imagem + @y0, 0)
  end

  def desenhe_navio_destruido(window, linha, coluna)
    color = Gosu::Color::RED
    window.draw_rect(coluna * @altura_imagem + @x0, linha * @largura_imagem + @y0, @largura_imagem, @altura_imagem, color)
  end

  def terminou_de_posicionar
    @navios_posicionados == @navios.size
  end

  def testar_esquerda(_window,linha, coluna)
   while (@errou ==false)
      cordx = (coluna - 1) * @altura_imagem + @x0
     puts cordx
      cordy = linha * @altura_imagem + @y0
     puts cordy
     atirar(_window,cordx, cordy)
   end
  end
  def testar_direita(_window,linha, coluna)
    while (@errou ==false)
      cordx = (coluna + 1) * @altura_imagem + @x0
      puts cordx
      cordy = linha * @altura_imagem + @y0
      puts cordy
      atirar(_window,cordx, cordy)
    end
  end
  def testar_cima(_window,linha, coluna)
    while (@errou ==false)
      cordx = (coluna) * @altura_imagem + @x0
      puts cordx
      cordy = (linha + 1) * @altura_imagem + @y0
      puts cordy
      atirar(_window,cordx, cordy)
    end
  end

  def testar_baixo(_window,linha, coluna)
    while (@errou ==false)
      cordx = (coluna) * @altura_imagem + @x0
      puts cordx
      cordy = (linha - 1) * @altura_imagem + @y0
      puts cordy
      atirar(_window,cordx, cordy)
    end
  end
  end

