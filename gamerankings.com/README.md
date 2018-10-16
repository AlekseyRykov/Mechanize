## Goals
1. PlayStation 2 list of games (97 pages) - https://www.gamerankings.com/browse.html?site=ps2&cat=0&year=0&numrev=3&sort=2&letter=&search= - 
2. The following information is needed from every page (50 games per page):
    * ID
    * Platform
    * Title
    * Main genre << Second genre << Third genre << Forth genre
    * Rank
    * Link
3. Output:
    * JSON
    * SQLite

## Built with
* Ruby
* The Mechanize + nokogiri library
* SQLite
* JSON
* Total: 4807 titles

## TODO
* Export to https://morph.io/
* Additional code for regular data updating in DB with sqlite or active record


## Glossary
* grnks = gamerankings
* cln = clean
* cmnt = comments

##
_This is a training and not self-serving scraping project. Feel free to contact me with questions an suggestions._
