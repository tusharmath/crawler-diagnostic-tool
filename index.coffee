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
		if res or err.code
			response_code = rpad (if res then res.statusCode else err.code or 'N/A'), 20
			type = rpad target.type.toUpperCase(), 4
			
			if err or res.statusCode isnt 200
				console.log '!', type, response_code, target.link, '@', target.parentLink
			else
				console.log ' ', type, response_code, target.link
		else
			console.error err	

	crawler = new Crawler startUrl, requestor, extractor, onResponse
	crawler.setup()
	crawler.start()
#crawl()


module.exports = {crawl}