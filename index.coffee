req = require 'request'
cheerio = require 'cheerio'
url = require 'url'
Crawler =  require './lib/Crawler'
Requestor =  require './lib/Requestor'
Extractor =  require './lib/Extractor'


rpad = (str, max_width) ->
	str = str.toString()
	str += ' ' while str.length < max_width
	str

crawl = (startUrl = 'http://practo.com/hello', onResponse) ->

	requestor = new Requestor req
	extractor = new Extractor cheerio, startUrl, url

	onResponse = onResponse or (err, res, target) ->
		response_code = rpad (if res then res.statusCode else 'N/A'), 6
		type = rpad target.type.toUpperCase(), 4
		if err or res.statusCode isnt 200
			console.log '!', type, response_code, target.link, '@', target.parent.request.href
		else
			console.log ' ', type, response_code, target.link

	crawler = new Crawler startUrl, requestor, extractor, onResponse
	crawler.setup()
	crawler.start()
#crawl()


module.exports = {crawl}