module Codebreaker
  class SecretCodeManager
    DEFAULT_ATTEMPTS_COUNT = 8

    def initialize(current_round)
      @new_code = false
      @current_round = current_round
    end

    def read_code
    end

    def generate_code

    end

    alias_method :new_code, :new_code?

    def start(user_code)
      @secret_code = []
      @user_code = user_code
      4.times do
        @secret_code.push(rand(SECRET_CODE_RANGE))
      end
      p @secret_code
    end

    attr_accessor :new_code, :current_round
  end
end
