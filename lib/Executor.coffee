class Executor
	constructor: (@starturl, @requestor, @extractor, @onResponseCallback)->
		@loadedlinks = {}	

	_start_target: ->
		target = @_create_target @starturl, 'get'
		target.parent = request: href : @starturl
		target
		
	_create_target: (url, type)-> @extractor.create_target url, type
	
	_updateLinks: (response) ->	@loadedlinks[response.request.href] = true

	_isCrawlable: (link) ->
		false if link.indexOf @starturl is -1
		false if @loadedlinks[link] is true
		true

	_requestAll: (response) ->
		for target in @extractor.extract(response.body)
			if target and @loadedlinks[target.link] isnt yes
				@loadedlinks[target.link] = yes
				target.parent = response
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
		
module.exports = Executor

