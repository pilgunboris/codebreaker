require 'json'

module Codebreaker
  class SecretCodeManager
    SECRET_CODE_RANGE = 1..6

    def initialize(current_round)
      @current_round = current_round
    end

    def code
      if current_round == 1
        generate_code
      else
        read_from_file
      end
    end

    private

    def read_from_file
      content = JSON.parse(File.read('secret_code_storage.json'))
      content['code']
    end

    def write_to_file(code)
      json = { code: code }.to_json
      File.open('secret_code_storage.json', 'w+') do |f|
        f.write(json)
      end
    end

    def generate_code
      code = 4.times.map { rand(SECRET_CODE_RANGE) }
      write_to_file(code)
      code
    end

    attr_accessor :new_code, :current_round
  end
end
