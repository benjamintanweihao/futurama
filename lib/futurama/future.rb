require 'thread'

module Futurama
  class Future < Delegator

    def initialize(&block)
      @block  = block
      @queue  = SizedQueue.new(1)
      @mutex  = Mutex.new
      Thread.new { run_future }
    end

    def run_future
      @queue.push(value: @block.call)
    rescue ::Exception => ex
      @queue.push(exception: ex)
    end

    def __getobj__
      resolved_future_or_raise[:value]
    end

    def resolved_future_or_raise
      @resolved_future || @mutex.synchronize do
        @resolved_future ||= @queue.pop
      end

      if @resolved_future[:exception]
        Kernel.raise @resolved_future[:exception]
      else
        @resolved_future
      end
    end

  end
end

Kernel