require 'spec_helper'
require 'timeout'

module Futurama
  describe 'Future' do

    it 'returns a value' do
      future = Future.new { 1 + 2 }

      expect(future).to eq(3)
    end

    it 'executes the computation in the background' do
      future = Future.new { sleep(1); 42 }

      sleep(1) # do some computation

      Timeout::timeout(0.9) do
        expect(future).to eq(42)
      end
    end

    it 'captures exceptions and re-raises them' do
      Thread.abort_on_exception=true

      error_msg = 'Good news, everyone!'

      future = Future.new { raise error_msg }

      expect { future.inspect }.to raise_error RuntimeError, error_msg
    end

    it 'delegates methods to the underlying object' do
      array = [1, 2, 3]
      future = Future.new { array }

      expect(future.map { |x| x * x }).to eq([1, 4, 9])
    end

    it 'works with multiple futures' do
      f1 = Future.new { sleep(1); 1}
      f2 = Future.new { sleep(1); 2}
      f3 = Future.new { sleep(1); 3}

      sleep(1)

      Timeout::timeout(1) do
        expect(f1 + f2 + f3).to eq(6)
      end
    end

    it 'works with a future depending on the result of another future' do
      f1 = Future.new { sleep(1); 1 }
      f2 = Future.new { f1 + 1;}
      f3 = Future.new { f2 + 1;}

      sleep(1)

      Timeout::timeout(1) do
        expect(f1 + f2 + f3).to eq(6)
      end

    end

    it 'pollutes the Kernel namespace' do
      msg    = 'Do the Bender!'
      future = future { msg }

      expect(future).to eq(msg)
    end

  end
end
