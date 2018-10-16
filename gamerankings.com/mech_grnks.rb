# add require statements
require 'rubygems'
require 'mechanize'
require 'json'

# an OpenSSL certificate store for verifying server certificates
# retrieve a copy of the set from Mozilla: curl.haxx.se/docs/caextract.html
# create a certificate store from the pem file
cert_store = OpenSSL::X509::Store.new
cert_store.add_file 'cacert.pem'

# create a new mechanize object
agent = Mechanize.new

# have mechanize use certificate
agent.cert_store = cert_store

# use the instance to fetch a page
page = agent.get("https://www.gamerankings.com/browse.html?site=ps2&cat=0&year=0&numrev=3&sort=2&letter=&search=")

# create array for our data
playstation2 = []

# variable used to track the last page and halt the loop
next_page = true

# while loop executes while a condition is true
while next_page

# when a page is fetched, the agent will parse the page and put a list of links
# using shortcut, which help us find a link to click on, each link contain this part of code '/ps2/'
  game_page = page.links_with(:href => %r{^/ps2/\w+})

# use map method and run the block for each element
  game_page.map do |link|

# consistently fetch pages
    l = link.click

# scrape data
    platform = l.search('.crumbs a[1]').text
    title = l.search('h1[2]').text
    main_genre = l.search('.crumbs a[2]').text
    second_genre = l.search('.crumbs a[3]').text
    third_genre = l.search('.crumbs a[4]').text
    forth_genre = l.search('.crumbs a[5]').text
    rank = l.search('span b').text
    game_link = l.search('li.hi a').map { |link| 'https://www.gamerankings.com'+link['href'] }

# append the given objects on to the end of array
    playstation2.push(
      title: title,
      genre: [main_genre, second_genre, third_genre, forth_genre],
      platform: platform,
      rank: rank,
      link: game_link
      )
  end

# check for next page existence, fetch it if true and override the instance, and halt the loop if false
  if page.body.include?('Next Page')
    n_page = page.link_with(:text => 'Next Page').click
    page = agent.get(n_page)
  else
    next_page = false
  end

end

# convert the result to JSON
# output can be redirected to a file, or piped into another program for further processing
puts JSON.pretty_generate(playstation2)










