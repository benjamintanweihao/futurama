require '../lib/futurama'
require 'open-uri'
require 'json'
require 'benchmark'

class Chucky
  URL = 'http://api.icndb.com/jokes/random'

  def sequential
    open(URL) do |f|
      f.each_line { |line| puts JSON.parse(line)['value']['joke'] }
    end
  end

  def concurrent
    future { sequential }
  end

end

chucky = Chucky.new

Benchmark.bm do |x|
  x.report('concurrent') { 10.times { chucky.concurrent } }
  x.report('sequential') { 10.times { chucky.sequential } }
end
