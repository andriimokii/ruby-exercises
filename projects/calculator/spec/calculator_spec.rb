require_relative '../lib/calculator'

describe Calculator do
  describe '#add' do
    it 'returns sum of two numbers' do
      calc = Calculator.new
      expect(calc.add(1, 1)).to eql(2)
    end

    it "returns the sum of more than two numbers" do
      calculator = Calculator.new
      expect(calculator.add(2, 5, 7)).to eql(14)
    end
  end

  describe '#multiply' do
    it 'returns product of any numbers' do
      calc = Calculator.new
      expect(calc.multiply(2, 2, 2)).to eql(8)
    end
  end

  describe '#subtract' do
    it 'returns difference of two numbers' do
      calc = Calculator.new
      expect(calc.subtract(5, 2)).to eql(3)
    end
  end

  describe '#divide' do
    it 'returns quotient of two numbers' do
      calc = Calculator.new
      expect(calc.divide(1, 2)).to eql(0.5)
    end
  end
end
