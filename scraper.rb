require 'open-uri'
require 'json'

class Scraper
  def self.wikiLookup(subject)
    page = wikiGetPage(subject)

    if page == nil
      STDERR.puts "ERROR: Wikipedia entry for #{subject} was not found."
      return
    end

    res = JSON.parse(open("http://en.wikipedia.org/w/api.php?action=parse" <<
                          "&page=#{URI::encode(page)}" <<
                          "&format=json&prop=text&section=0").read)

    # TODO: handle errors here?
    title = res["parse"]["title"]
    text = res["parse"]["text"]["*"]

    # Complicated stuff...
    # 1. Find all strings between <p>..</p> tags
    # 2. Join these paragraphs with a newline and tab (formatting)
    # 3. Remove all HTML tags (and pray that its well formatted)
    text = "\t#{text.scan(/<p>.*<\/p>/).join("\n\t").gsub(%r{</?[^>]+?>}, '')}"

    puts title
    title.length.times { print "-" }; print "\n"
    puts "#{text}\n\n"

    nil
  end

  def self.dictLookup(word)
    # TODO
  end

  private

  def self.wikiGetPage(subject)
    res = JSON.parse(open("http://en.wikipedia.org/w/api.php?action=query" <<
                          "&list=search&format=json&srsearch=" <<
                          "#{URI::encode(subject)}&srprop=score%7Csnippet" <<
                          "&srlimit=10").read)

    debug_puts res

    # get the list from the JSON response, and return nil if no matches
    result_list = res["query"]["search"]
    return nil if result_list.empty?

    title = result_list[0]["title"]
    debug_puts "title found: '#{title}'"

    # return first search result's title
    title
  end
end
