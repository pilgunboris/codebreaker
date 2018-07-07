require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    subject { Game.new }

    context 'user_input' do
      it 'accepts 4 valid numbers' do
        $stdin = StringIO.new("1\n2\n3\n4\n")
        expect do
          subject.validate_user_input
          $stdin = STDIN
        end.to change { subject.instance_variable_get(:@user_code) }.from([]).to([1, 2, 3, 4])
      end

      it 'accepts 4 valid numbers if some invalid provided' do
        $stdin = StringIO.new("1\n8\n3\n4\n3\n")
        expect do
          subject.validate_user_input
          $stdin = STDIN
        end.to change { subject.instance_variable_get(:@user_code) }.from([]).to([1, 3, 4, 3])
      end
    end

    context '#initialize' do
      it 'saves secret code' do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(subject.instance_variable_get(:@secret_code).size).to eq 4
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(subject.instance_variable_get(:@secret_code)).to consist_from(Codebreaker::Game::SECRET_CODE_RANGE)
      end
    end

    context '#check_result' do
      before do
        game = double
        # allow(game).to receive(:start).and_throw(:@secret_code, [6, 1, 3, 4])
        subject.instance_variable_set :@secret_code, [6, 1, 3, 4]
      end

      it 'when first number the same' do
        subject.instance_variable_set :@user_code, [6, 2, 5, 2]
        expect(subject.prepare_result).to eq(['+'])
      end

      it 'when two numbers match' do
        subject.instance_variable_set :@user_code, [6, 2, 3, 2]
        expect(subject.prepare_result).to eq(['+', '+'])
      end

      it 'when three numbers match' do
        subject.instance_variable_set :@user_code, [6, 1, 5, 4]
        expect(subject.prepare_result).to eq(["+", "+", "+"])
      end

      it 'when number is guessed but position is incorrect' do
        subject.instance_variable_set :@user_code, [4, 2, 5, 2]
        expect(subject.prepare_result).to eq(["-"])
      end

      it 'when two numders is guessed but position is incorrect' do
        subject.instance_variable_set :@user_code, [1, 3, 5, 2]
        expect(subject.prepare_result).to eq(["-", "-"])
      end

      it 'when three numders is guessed but position is incorrect' do
        subject.instance_variable_set :@user_code, [4, 3, 6, 2]
        expect(subject.prepare_result).to eq(["-", "-", "-"])
      end

      it 'when all numbers guessed but two numbers have incorrect position' do
        subject.instance_variable_set :@user_code, [1, 6, 3, 4]
        expect(subject.prepare_result).to eq(["-", "-", "+", "+"])
      end

      it 'when secret code is [1244] and user puts [1242] should return +++' do
        subject.instance_variable_set :@secret_code, [1, 2, 4, 4]
        subject.instance_variable_set :@user_code, [1, 2, 4, 2]
        expect(subject.prepare_result).to eq(["+", "+", "+"])
      end
    end

    context '#hint' do
      it 'should return one number of secret code' do
        subject.instance_variable_set :@secret_code, [6, 1, 3, 4]
        expected_array = ['***4', '**3*', '*1**', '6***']
          expect(expected_array).to include(subject.hint)
      end

      it 'hint can be taken once' do
        subject.hint
        expect(subject.instance_variable_get(:@hint)).to be_falsey
      end
    end

    context '#won' do # wrong test
      it 'sets game result into win' do
        expect(subject.send(:won)).to be_truthy
      end
    end

    context '#lost' do
      it 'should return message when game over' do
        expect(subject.send(:lost)).to be_falsey
      end
    end
  end
end
