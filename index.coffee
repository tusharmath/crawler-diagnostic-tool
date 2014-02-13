req = require 'request'
cheerio = require 'cheerio'
url = require 'url'
Executor =  require './lib/Executor'
Requestor =  require './lib/Requestor'
Extractor =  require './lib/Extractor'


rpad = (str, max_width) ->
	str += ' ' while str.length < max_width
	str

crawl = (startUrl = 'http://practo.com/hello', onResponse) ->

	requestor = new Requestor req
	extractor = new Extractor cheerio, startUrl, url

	onResponse = onResponse or (err, res, target) ->
		response_code = rpad res?.statusCode or 'N/A', 6
		type = rpad target.type.toUpperCase(), 6
		if err or res.statusCode isnt 200
			console.log '!', type, response_code, target.link, '@', target.parent.request.href
		else
			console.log ' ', type, response_code, target.link

	executor = new Executor startUrl, requestor, extractor, onResponse
	executor.setup()
	executor.start()
#crawl()


module.exports = {crawl}