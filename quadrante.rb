class Quadrante
  attr_accessor :parte_navio

  def initialize
    @parte_navio = nil
    @atacado = false
  end
  
  def atacado?
    @atacado
  end

  def atacar!
    @atacado = true
    unless @parte_navio.nil?
      @parte_navio.atacar!
    end
  end
end
