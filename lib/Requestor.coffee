class Requestor
	constructor: (@requestClient)->
		
	setContext: (@context) ->

	_defaults: (url) ->
		options = 
			url: url
			headers: 
				'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.107 Safari/537.36'
		
			


	
	_fetch: (link, type, callback) ->
		if not link or not type or not callback
			throw new Error 'link, type, callback are all required'
		@requestClient[type] @_defaults(link), callback

	_onResponse: (error, response, callback, target) ->
		callback.call @context, error, response, target
	
	_request: (target, callback) ->
		
		if target.type isnt 'get' and target.type isnt 'head'
			throw new Error 'Target.type should be get or head'
		@_fetch target.link, target.type, (error, response) =>
			@_onResponse error, response, callback, target

	request: (target, callback) ->
		@_request target, callback


module.exports = Requestor