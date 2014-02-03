require('coffee-trace')
Crawler = require("crawler").Crawler
cheerio = require 'cheerio'


class Validator 
	constructor: (@hostname, @cheerio)->
		@loadedlinks = {}
		@crawlerCount = 0

	_createDummyParentResponse: ->
		request: href : '/'

	_isloaded : (link) -> if @loadedlinks[link] is yes then yes else no
		
	_qualifyUrl : (url) ->
		return "http:#{url}" if url.match(/^\/\//)
		return url if url.match(/https*/)
		return "http:#{url}" if url.match('www')
		@hostname + url 

	_onServerError: (response, parentResponse, requestLink)->
		console.log 'ERROR:', response.statusCode, requestLink
		console.log 'PAGE-REQUEST:', parentResponse.request.href
		console.log ''

	_onClientError: (error, parentResponse, requestLink) ->
		console.log "ERROR:",  requestLink
		console.log 'PAGE-REQUEST:', parentResponse.request.href
		console.log ''

	_getFullyQualifiedLinks: (response) ->
		result = []
		for a in @cheerio.load(response.body)('a')
			href =  a.attribs.href
			result.push @_qualifyUrl href if href
		return result

	_onComplete: -> console.log 'Completed, closing connections...'

	_onDrain: ->
		@crawlerCount--
		@_onComplete() if @crawlerCount is 0

	_requestCrawler: (callback, onDrain, maxConnections = 10, jQuery = false)->
		@crawlerCount++
		new Crawler {callback, onDrain, maxConnections, jQuery}

	_crawl : (link, parentResponse)->
		#console.log link, parentResponse.request.href
		callback = (error, response) => @_onResponse error, response, parentResponse, link
		onDrain = => @_onDrain()

		@_requestCrawler(callback, onDrain).queue link

	_onResponse: (error, response, parentResponse, requestLink) ->

		if error
			@_onClientError error, parentResponse, requestLink
		else if response.statusCode isnt 200
			@_onServerError response, parentResponse, requestLink

		#Stop crawling sites out of the set hostname
		else if response.request.href.match @hostname
			for link in @_getFullyQualifiedLinks response
				if @_isloaded(link) is no
					@_crawl link, response
					@loadedlinks[link] = yes
	start : ->
		@_crawl @hostname, @_createDummyParentResponse()



v = new Validator 'http://stag-website-scene.practo.com', cheerio
v.start()