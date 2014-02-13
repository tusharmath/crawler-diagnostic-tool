class Crawler
	constructor: (@starturl, @requestor, @extractor, @onResponseCallback)->
		@loadedlinks = {}	

	_start_target: ->
		target = @extractor.create_target @starturl, @starturl, 'get'
		target.parent = request: href : @starturl
		target
	
	_updateLinks: (response) ->	@loadedlinks[response.request.href] = true

	_isCrawlable: (link) ->
		false if link.indexOf @starturl is -1
		false if @loadedlinks[link] is true
		true

	_requestAll: (response) ->
		for target in @extractor.extract(response.body, response.request.href)
			if target and @loadedlinks[target.link] isnt yes
				@loadedlinks[target.link] = yes
				@_request target

	_onResponse: (error, response, target) =>
		if not error and response.statusCode is 200
			@_updateLinks response
			@_requestAll response, target			
		
		@onResponseCallback error, response, target

	_request: (target) ->
		if @_isCrawlable target.link
			@requestor.request target, @_onResponse

	setup: ->
		@requestor.setContext @
	
	start: -> @_request @_start_target() 
		
module.exports = Crawler

