#!/usr/bin/env ruby

require 'optparse'

require './scraper'

$options = {}
def debug_puts(arg)
  puts "DEBUG: #{arg}" if $options[:debug]
end

OptionParser.new do |opts|
  opts.banner = "Usage: define [options] subjects"

  opts.on("--debug", "Use debugging statements") do |debug|
    $options[:debug] = true
  end

  opts.on("-a", "--all", "Force lookup in all sources") do |a|
    $options[:dict] = true
    $options[:wiki] = true
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

puts "Usage: define [options] subjects" if ARGV.size == 0

ARGV.each do |subject|
  debug_puts "subject is #{subject}"

  if $options[:wiki] || $options[:dict]
    debug_puts "forced lookups"
    Scraper.wikiLookup(subject) if $options[:wiki]
    Scraper.dictLookup(subject) if $options[:dict]
  else
    Scraper.wikiLookup(subject)

    if not subject.include? " "
      debug_puts "no dict lookup for multi-word subject"
      Scraper.dictLookup(subject)
    end
  end
end
