# require_relative 'game_interface'

module Codebreaker
  class Game
    # include GameInterface
    DEFAULT_ATTEMPTS_COUNT = 8
    SECRET_CODE_RANGE = 1..6
    NUMBERS_TO_WORDS = {
        0 => 'first',
        1 => 'second',
        2 => 'third',
        3 => 'fourth'
    }.freeze

    def initialize(user_code, current_round)
      @hint = true
      @secret_code = [1,2,3,4]
      @current_round = valid_current_round(current_round)
      start(user_code.split('').map(&:to_i))
    end

    def valid_current_round(current_round)
      unless (1..8).to_a.include?(current_round.to_i)
        fail "Invalid round number provided! - #{current_round}"
      end
      current_round.to_i
    end

    def start(user_code)

      @user_code = user_code
      # 4.times do
      #   @secret_code.push(rand(SECRET_CODE_RANGE))
      # end
      p @secret_code
    end

    def run
      # if @current_round <= DEFAULT_ATTEMPTS_COUNT
      #   # read_secret_code
      #   else
      #
      #   # reset_secret_code
      #   # lost
      # end

           # 2
      jsoned_result
      # @current_round += 1 # 3
      # puts "#{DEFAULT_ATTEMPTS_COUNT - @current_round} attempts left\n"
    end

    def jsoned_result
      {
        current_round: (@current_round + 1),
        attempts_left: (DEFAULT_ATTEMPTS_COUNT - @current_round),
        won: won?,
        lost: lost?,
        round_result: prepare_round_result,
        hint_shown: false # TODO: write this to file
      }
    end

    def lost?
      @current_round == DEFAULT_ATTEMPTS_COUNT && !won?
    end

    # def jsoned_hint
    #   {
    #     hint: '**1',
    #     hint_shown: 'true'/'false'
    #   }
    # end
    #
    # def validate_user_input
    #   @user_code = []
    #   4.times do |index|
    #     puts "Enter #{NUMBERS_TO_WORDS[index]} number from 1 to 6:"
    #     number = 0
    #     while !number_valid?(number) do
    #       number = $stdin.gets.chomp.to_i
    #       puts 'Use only numbers from 1 to 6!' unless number_valid?(number)
    #     end
    #     @user_code.push(number)
    #   end
    # end


    def prepare_round_result
      result = []
      common = @secret_code & @user_code
      puts "==========================="
      puts @secret_code
      puts @user_code
      @user_code.each_with_index.map do |value, index|
        if value == @secret_code[index]
          result.push '+'
          common.delete(value)
        elsif common.include?(value)
          result.push '-'
          common.delete(value)
        end
      end
      puts "Round result: #{result.join(' ')}"
      result.join(' ')
    end

    def hint
      @hint = false
      result = %w[* * * *]
      index = rand(4)
      result[index] = @secret_code[index]
      p result
      result.join
    end

    private

    # def number_valid?(number)
    #   number >= 1 && number <= 6
    # end

    def won?
      @user_code == @secret_code
    end

    # def won
    #   puts 'You won!'
    #   true
    # end
    #
    # def lost
    #   puts "You're looser!"
    #   false
    # end
  end
end
