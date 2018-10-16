# add require statements
require 'rubygems'
require 'mechanize'
require 'sqlite3'

# initialize db
db = SQLite3::Database.new 'games.sqlite'

# create table
db.execute 'CREATE TABLE IF NOT EXISTS playstation2 (
                    id           INTEGER PRIMARY KEY AUTOINCREMENT,
                    platform     TEXT,
                    title        TEXT,
                    main_genre   TEXT,
                    second_genre TEXT,
                    third_genre  TEXT,
                    forth_genre  TEXT,
                    rank         TEXT,
                    link         TEXT
)'

cert_store = OpenSSL::X509::Store.new
cert_store.add_file 'cacert.pem'

agent = Mechanize.new
agent.cert_store = cert_store

page = agent.get("https://www.gamerankings.com/browse.html?site=ps2&cat=0&year=0&numrev=3&sort=2&letter=&search=")

next_page = true

while next_page
  game_page = page.links_with(:href => %r{^/ps2/\w+})

  game_page.map do |link|
    l = link.click
    platform = l.search('.crumbs a[1]').text
    title = l.search('h1[2]').text
    main_genre = l.search('.crumbs a[2]').text
    second_genre = l.search('.crumbs a[3]').text
    third_genre = l.search('.crumbs a[4]').text
    forth_genre = l.search('.crumbs a[5]').text
    rank = l.search('span b').text
    game_link = l.search('li.hi a').map { |link| 'https://www.gamerankings.com'+link['href'] }

# insert data to db with injection prevention
    db.execute 'INSERT INTO playstation2
                        (platform, title, main_genre, second_genre, third_genre, forth_genre, rank, link)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                        [platform, title, main_genre, second_genre, third_genre, forth_genre, rank, game_link]
  end

  if page.body.include?('Next Page')
    n_page = page.link_with(:text => 'Next Page').click
    page = agent.get(n_page)
  else
    next_page = false
  end
end
