# add require statements.
require 'rubygems'
require 'mechanize'
require 'json'

cert_store = OpenSSL::X509::Store.new
cert_store.add_file 'cacert.pem'

agent = Mechanize.new
agent.cert_store = cert_store

page = agent.get("https://www.gamerankings.com/browse.html?site=ps2&cat=0&year=0&numrev=3&sort=2&letter=&search=")

playstation2 = []

next_page = true

while next_page

  g_page = page.links_with(:href => %r{^/ps2/\w+})
  g_page.map do |link|
    a = link.click
    platform = a.search('.crumbs a[1]').text
    title = a.search('h1[2]').text
    main_genre = a.search('.crumbs a[2]').text
    second_genre = a.search('.crumbs a[3]').text
    third_genre = a.search('.crumbs a[4]').text
    forth_genre = a.search('.crumbs a[5]').text
    rank = a.search('span b').text

    playstation2.push(
      title: title,
      genre: [main_genre, second_genre, third_genre, forth_genre],
      platform: platform,
      rank: rank,
      )
  end

  if page.body.include?('Next Page')
    n_page = page.link_with(:text => 'Next Page').click
    page = agent.get(n_page)
  else
    next_page = false
  end

end

puts JSON.pretty_generate(playstation2)










