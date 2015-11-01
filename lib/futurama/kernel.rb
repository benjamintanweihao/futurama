require 'futurama'

  module Kernel
    def future(&block)
      Futurama::Future.new(&block)
    end
  end