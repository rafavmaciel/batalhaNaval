# frozen_string_literal: true

class Machine

  def initialize(window, tabuleiro)
    @window = window
    @tabuleiro = tabuleiro
    @destruidos = 0
    @direcoes_nao_testadas = ['esquerda', 'direita', 'cima', 'baixo']
    @destruiu_ultimo_navio_que_acertou = true
  end

  def posicionar
    while not @tabuleiro.terminou_de_posicionar
      x = rand(@tabuleiro.matriz.size * @tabuleiro.largura_imagem) + @tabuleiro.x0
      y = rand(@tabuleiro.matriz.size * @tabuleiro.altura_imagem) + @tabuleiro.y0
      @tabuleiro.posicionar(x, y, [true, false].sample)
    end
  end

  def atirar_aleatoriamente
    posicao = Array.new(2)
    posicao[0] = rand(9)
    posicao[1] = rand(9)
    @tabuleiro.atirar_usando_linha_coluna(posicao[0], posicao[1])
    posicao
  end

  def atualizar_quantidade_de_destruidos
    @destruidos = navios_destruidos
  end

  def atualizar_direcoes
    @direcoes_nao_testadas = ['esquerda', 'direita', 'cima', 'baixo']
  end

  def atirar
    if @destruidos == 5
      return
    end
    if @destruiu_ultimo_navio_que_acertou
      posicao = atirar_aleatoriamente
      if not @tabuleiro.errou_o_tiro?
        atirar
      elsif @tabuleiro.acertou
        @linha = posicao[0]
        @coluna = posicao[1]
        @destruiu_ultimo_navio_que_acertou = false
        atirar
      end
    else
      if @direcoes_nao_testadas.include?('esquerda')
        testar_esquerda(@linha, @coluna)
        if mudou_a_quantidade_de_navios_destruidos?
          atualizar_quantidade_de_destruidos
          @destruiu_ultimo_navio_que_acertou = true
          atualizar_direcoes
          atirar
        elsif @tabuleiro.errou_o_tiro?
          @direcoes_nao_testadas.delete('esquerda')
        end
      elsif @direcoes_nao_testadas.include?('direita')
        testar_direita(@linha, @coluna)
        if mudou_a_quantidade_de_navios_destruidos?
          atualizar_quantidade_de_destruidos
          @destruiu_ultimo_navio_que_acertou = true
          atualizar_direcoes
          atirar
        elsif @tabuleiro.errou_o_tiro?
          @direcoes_nao_testadas.delete('direita')
          end
      elsif @direcoes_nao_testadas.include?('cima')
        testar_cima(@linha, @coluna)
        if mudou_a_quantidade_de_navios_destruidos?
          atualizar_quantidade_de_destruidos
          @destruiu_ultimo_navio_que_acertou = true
          atualizar_direcoes
          atirar
        elsif @tabuleiro.errou_o_tiro?
          @direcoes_nao_testadas.delete('cima')
        end
      elsif @direcoes_nao_testadas.include?('baixo')
        testar_baixo(@linha, @coluna)
        if mudou_a_quantidade_de_navios_destruidos?
          atualizar_quantidade_de_destruidos
          @destruiu_ultimo_navio_que_acertou = true
          atualizar_direcoes
          atirar
        elsif @tabuleiro.errou_o_tiro?
          @direcoes_nao_testadas.delete('baixo')
        end
      end
    end
  end

  def mudou_a_quantidade_de_navios_destruidos?
    quantidade = navios_destruidos
    quantidade != @destruidos
  end

  def navios_destruidos
    quantidade = 0
    @tabuleiro.navios.each do |navio|
      quantidade += 1 if navio.esta_destruido?
    end
    quantidade
  end

  def testar_esquerda(linha, coluna)
    unless @tabuleiro.errou_o_tiro? or mudou_a_quantidade_de_navios_destruidos?
      @tabuleiro.atirar_usando_linha_coluna(linha, coluna)
      testar_esquerda(linha, coluna - 1)
    end
    if not @tabuleiro.acertou and not @tabuleiro.errou_o_tiro?
      @direcoes_nao_testadas.delete('esquerda')
      atirar
    end
  end

  def testar_direita(linha, coluna)
    unless @tabuleiro.errou_o_tiro? or mudou_a_quantidade_de_navios_destruidos?
      @tabuleiro.atirar_usando_linha_coluna(linha, coluna)
      testar_direita(linha, coluna + 1)
    end
    if not @tabuleiro.acertou and not @tabuleiro.errou_o_tiro?
      @direcoes_nao_testadas.delete('direita')
      atirar
    end
  end

  def testar_cima(linha, coluna)
    unless @tabuleiro.errou_o_tiro? or mudou_a_quantidade_de_navios_destruidos?
      @tabuleiro.atirar_usando_linha_coluna(linha, coluna)
      testar_cima(linha - 1, coluna)
    end
    if not @tabuleiro.acertou and not @tabuleiro.errou_o_tiro?
      @direcoes_nao_testadas.delete('cima')
      atirar
    end
  end

  def testar_baixo(linha, coluna)
    unless @tabuleiro.errou_o_tiro? or mudou_a_quantidade_de_navios_destruidos?
      @tabuleiro.atirar_usando_linha_coluna(linha, coluna)
      testar_baixo(linha + 1, coluna)
    end
    if not @tabuleiro.acertou and not @tabuleiro.errou_o_tiro?
      @direcoes_nao_testadas.delete('baixo')
      atirar
    end
  end
end
