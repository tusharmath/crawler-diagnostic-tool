req = require 'request'
cheerio = require 'cheerio'
url = require 'url'
Executor =  require './lib/Executor'
Requestor =  require './lib/Requestor'
Extractor =  require './lib/Extractor'

module.exports = crawl: (startUrl = 'http://tusharm.com', onResponse) ->

	requestor = new Requestor req
	extractor = new Extractor cheerio, startUrl, url

	onResponse = onResponse or (err, res, target) ->
		if err
			console.log '!', target.type.toUpperCase(), '\t', target.link, '@', target.parent.request.href
		else
			console.log target.type.toUpperCase(), '\t', target.link

	executor = new Executor startUrl, requestor, extractor, onResponse
	executor.setup()
	executor.start()