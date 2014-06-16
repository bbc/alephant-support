require 'alephant/support/aop'

class Test
  extend Alephant::Support::AOP

  def test_method(arg)
    'test_return'
  end

end
