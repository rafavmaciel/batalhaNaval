# frozen_string_literal: true

class Machine
  def initialize(window, tabuleiro)
    @window = window
    @tabuleiro = tabuleiro
    @destruidos = 0
    @direcoes_nao_testadas = %w[cima esquerda baixo direita]
    @destruiu_ultimo_navio_que_acertou = true
  end

  def posicionar
    until @tabuleiro.terminou_de_posicionar
      x = rand(@tabuleiro.matriz.size * @tabuleiro.largura_imagem) + @tabuleiro.x0
      y = rand(@tabuleiro.matriz.size * @tabuleiro.altura_imagem) + @tabuleiro.y0
      @tabuleiro.posicionar(x, y, [true, false].sample)
    end
  end

  def atirar_aleatoriamente
    posicao = Array.new(2)
    posicao[0] = rand(10)
    posicao[1] = rand(10)
    @tabuleiro.atirar_usando_linha_coluna(posicao[0], posicao[1])
    posicao
  end

  def atualizar_quantidade_de_destruidos
    @destruidos = navios_destruidos
  end

  def atualizar_direcoes
    @direcoes_nao_testadas = %w[esquerda direita cima baixo]
  end

  def atirar
    return if @destruidos == 5

    if @destruiu_ultimo_navio_que_acertou
      posicao = atirar_aleatoriamente
      if !@tabuleiro.acertou && !@tabuleiro.jogada_invalida
        return
      elsif @tabuleiro.acertou
        @linha = posicao[0]
        @coluna = posicao[1]
        @destruiu_ultimo_navio_que_acertou = false
        atirar
      elsif @tabuleiro.jogada_invalida
        atirar
      end
    else
      case @direcoes_nao_testadas[0]
      when 'direita'
        @tabuleiro.acertou = true
        direita
      when 'esquerda'
        @tabuleiro.acertou = true
        esquerda
      when 'cima'
        @tabuleiro.acertou = true
        cima
      when 'baixo'
        @tabuleiro.acertou = true
        baixo
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

  def atualizar_prioridade_das_diredores(direcao)
    index = 0
    if direcao == 'direita' and @direcoes_nao_testadas.include?('esquerda')
      index = @direcoes_nao_testadas.find_index('esquerda')
    elsif direcao == 'esquerda' and @direcoes_nao_testadas.include?('direita')
      index = @direcoes_nao_testadas.find_index('direita')
    elsif direcao == 'cima' and @direcoes_nao_testadas.include?('baixo')
      index = @direcoes_nao_testadas.find_index('baixo')
    elsif direcao == 'baixo' and @direcoes_nao_testadas.include?('cima')
      index = @direcoes_nao_testadas.find_index('cima')
    end
    @direcoes_nao_testadas[0] = @direcoes_nao_testadas[index]
    @direcoes_nao_testadas.delete(direcao)
  end

  def testar_esquerda(linha, coluna)
    if @tabuleiro.acertou && !mudou_a_quantidade_de_navios_destruidos?
      atualizar_prioridade_das_diredores('esquerda')
      @tabuleiro.atirar_usando_linha_coluna(linha, coluna)
      testar_esquerda(linha, coluna - 1) unless coluna.zero?
    end
  end

  def testar_direita(linha, coluna)
    if @tabuleiro.acertou && !mudou_a_quantidade_de_navios_destruidos?
      atualizar_prioridade_das_diredores('direita')
      @tabuleiro.atirar_usando_linha_coluna(linha, coluna)
      testar_direita(linha, coluna + 1) unless coluna == 9
    end
  end

  def testar_cima(linha, coluna)
    if @tabuleiro.acertou && !mudou_a_quantidade_de_navios_destruidos?
      atualizar_prioridade_das_diredores('cima')
      @tabuleiro.atirar_usando_linha_coluna(linha, coluna)
      testar_cima(linha - 1, coluna) unless linha.zero?
    end
  end

  def testar_baixo(linha, coluna)
    if @tabuleiro.acertou && !mudou_a_quantidade_de_navios_destruidos?
      atualizar_prioridade_das_diredores('baixo')
      @tabuleiro.atirar_usando_linha_coluna(linha, coluna)
      testar_baixo(linha + 1, coluna) unless linha == 9
    end
  end

  private

  def baixo
    testar_baixo(@linha + 1, @coluna)
    if mudou_a_quantidade_de_navios_destruidos?
      atualizar_quantidade_de_destruidos
      @destruiu_ultimo_navio_que_acertou = true
      atualizar_direcoes
      atirar
    elsif @tabuleiro.jogada_invalida
      atirar
    end
  end

  def cima
    testar_cima(@linha - 1, @coluna)
    if mudou_a_quantidade_de_navios_destruidos?
      atualizar_quantidade_de_destruidos
      @destruiu_ultimo_navio_que_acertou = true
      atualizar_direcoes
      atirar
    elsif @tabuleiro.jogada_invalida
      atirar
    end
  end

  def direita
    testar_direita(@linha, @coluna + 1)
    if mudou_a_quantidade_de_navios_destruidos?
      atualizar_quantidade_de_destruidos
      @destruiu_ultimo_navio_que_acertou = true
      atualizar_direcoes
      atirar
    elsif @tabuleiro.jogada_invalida
      atirar
    end
  end

  def esquerda
    testar_esquerda(@linha, @coluna - 1)
    if mudou_a_quantidade_de_navios_destruidos?
      atualizar_quantidade_de_destruidos
      @destruiu_ultimo_navio_que_acertou = true
      atualizar_direcoes
      atirar
    elsif @tabuleiro.jogada_invalida
      atirar
    end
  end
end
