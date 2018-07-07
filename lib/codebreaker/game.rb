# require_relative 'game_interface'


module Codebreaker
  class Game
    # include GameInterface
    DEFAULT_ATTEMPTS_COUNT = 8
    NUMBERS_TO_WORDS = {
        0 => 'first',
        1 => 'second',
        2 => 'third',
        3 => 'fourth'
    }.freeze

    def initialize(user_code, current_round)
      @hint = true
      @current_round = valid_current_round(current_round)
      @secret_code = Codebreaker::SecretCodeManager.new(@current_round).code
      # puts "CODE CURRENTLY:"
      # puts @secret_code
      @user_code = user_code.split('').map(&:to_i)
    end

    def valid_current_round(current_round)
      unless (1..8).to_a.include?(current_round.to_i)
        fail "Invalid round number provided! - #{current_round}"
      end
      current_round.to_i
    end

    def run
      jsoned_result
    end

    def jsoned_result
      {
        current_round: calculate_current_round,
        attempts_left: (DEFAULT_ATTEMPTS_COUNT - @current_round),
        won: won?,
        lost: lost?,
        round_result: prepare_round_result
      }
    end

    def calculate_current_round
      if @current_round < DEFAULT_ATTEMPTS_COUNT
        @current_round + 1
      else
        1
      end
    end

    def lost?
      @current_round == DEFAULT_ATTEMPTS_COUNT && !won?
    end

    def prepare_round_result
      result = []
      common = @secret_code & @user_code
      @user_code.each_with_index.map do |value, index|
        if value == @secret_code[index]
          result.push '+'
          common.delete(value)
        elsif common.include?(value)
          result.push '-'
          common.delete(value)
        end
      end
      result.join(' ')
    end

    def hint
      @hint = false
      result = %w[* * * *]
      index = rand(4)
      result[index] = @secret_code[index]
      { hint: result.join }
    end

    private

    def won?
      @user_code == @secret_code
    end
  end
end
