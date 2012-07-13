if RUBY_VERSION =~ /1.9/
  Encoding.default_external = "ASCII-8BIT"
  Encoding.default_internal = "ASCII-8BIT"
end

$:.push File.dirname(__FILE__)+"/../lib"
require 'wolverine'
include Wolverine
require 'benchmark'

def run
  file = File.dirname(__FILE__)+"/2012-04-30_mint_production.log"
  bytes = File.size(file)
  puts "Processing #{bytes / 1024 / 1024} MB, #{file}"

  Benchmark.bm(15) do |x|
    def x.report(*args)
      puts
      start_rss = rss
      result = nil
      tms = super do
        result = yield
      end
      end_rss = rss
      msg = "RSS: #{end_rss}, chg: #{end_rss - start_rss}"
      delta = tms.real
      bytes = 0
      cnt = 0
      if result.respond_to? :size and result.size == 2 and
          result.all? {|x| x.integer? }
        cnt, bytes = result
      elsif result.respond_to? :each
        result.each {|elt| bytes+=elt.to_s.length; cnt+=1 }
      end
      msg += ", #{cnt} at #{(cnt/delta).round}/s"
      msg += ", #{bytes / 1_000_000}MB at #{(8 * bytes / 1_000_000 / delta).round}Mbit/s"
      puts msg
      tms
    end
   
    x.report("cat") { system "time cat #{file} > /dev/null"; [0, bytes] }
    x.report("gzip -d") { system "time gzip -d < #{file}.gz > /dev/null"; [0, bytes] }
    #x.report("ruby -e") { system "time ruby -e '$stdin.each do |l| $stdout.write l; end' < #{file} > /dev/null"; [0, bytes] }
    
    File.open(file, "r") do |f|
      cnt = 0
      x.report("in-proc count") { f.each do |l| cnt += 1; end; [cnt, bytes] }
      puts "line count: #{cnt}"
    end

    src = FileSource.new("#{file}.gz")
    cnt = 0
    x.report("gzfile src") { src.each do |ev| cnt += 1; end; [cnt, bytes] }

    src = FileSource.new(file)
    cnt = 0
    x.report("file src") { src.each do |ev| cnt += 1; end; [cnt, bytes] }

    cnt = 0
    x.report("file append") { src.append_indented.each do |ev| cnt += 1; end; [cnt, bytes] }

    arr = nil

    x.report("file head to_a") { arr = src.head(cnt / 10).to_a }

    x.report("arr append") { arr = arr.append_indented.to_a }

    x.report("arr field (2shrt)") do
      a = arr.field(/\A.*? (pepper|mint) .*?\[(\d+)\]: /m, 
          :host, :pid).to_a
    end

    x.report("arr field (2)") do
      a = arr.field(/\A\w{3} +\d{1,2} \d{1,2}:\d{2}:\d{2}.\d{6} (\w+) \w+ \w+\[(\d+)\]: .*\Z/m, 
          :host, :pid).to_a
    end

    x.report("arr field (8)") do
      arr = arr.field(/\A(\w{3}) +(\d{1,2}) (\d{1,2}:\d{2}:\d{2}.\d{6}) (\w+) (\w+) (\w+)\[(\d+)\]: (.*)\Z/m, 
          :month, :day, :time, :host, :log_level, :progname, :pid, :msg).to_a
    end

    x.report("arr group") do
      arr = arr.group(:following => [:host, :pid], :from => /: Processing /).to_a
    end

    x.report("arr field (4) req") do
      arr = arr.field(/\A.+: Processing (\w+)#(\w+)(?:.|\n)+: Completed in ([0-9.]+) .+ \[(.+)\]/,
          :controller, :action, :delta, :url).to_a
    end

    x.report("all together now") do
      src.head(cnt / 10).
        append_indented.
        field(/\A.*? (pepper|mint) .*?\[(\d+)\]: /m, :host, :pid).
        group(:following => [:host, :pid], :from => /: Processing /).
        field(/\A.+: Processing (\w+)#(\w+)(?:.|\n)+: Completed in ([0-9.]+) .+ \[(.+)\]/,
          :controller, :action, :delta, :url).
        to_a
    end
  end
end

def rss
  `ps -o pid,user,rss,args -p #$$`.split("\n")[1].split(/\s+/)[2].to_i
end

def rates(tms, result)
  if result.respond_to? :each
    delta = tms.real
    bytes = 0
    cnt = 0
    result.each {|elt| bytes+=elt.to_s.length; cnt+=1 }
    puts "#{cnt} at #{(cnt/delta).round}/s, #{bytes / 1_000_000}MB at #{8 * bytes / 1_000_000}Mbit/s"
  end
end

run

exit
