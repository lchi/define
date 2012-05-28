#!/usr/bin/env ruby

require 'optparse'

$options = {}
def debug_puts(arg)
  puts "DEBUG: #{arg}" if $options[:debug]
end

OptionParser.new do |opts|
  opts.banner = "Usage: define [options] subjects"

  opts.on("--debug", "Use debugging statements") do |debug|
    $options[:debug] = true
  end

  opts.on("-d", "--dict", "Force lookup in dictionary") do |d|
    $options[:dict] = true
  end

  opts.on("-w", "--wiki", "Force lookup on Wikipedia") do |w|
    $options[:wiki] = true
  end

  # TODO: Add language flag

end.parse!

debug_puts "Options: #{$options}"

class Scraper
  def self.wikiLookup(subject)
  end

  def self.dictLookup(word)

  end
end

ARGV.each do |subject|
  debug_puts "subject is #{subject}"
end
