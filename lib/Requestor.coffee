class Requestor
	constructor: (@requestClient)->
		
	setContext: (@context) ->
	
	_fetch: (link, type, callback) ->
		if not link or not type or not callback
			throw new Error 'link, type, callback are all required'
		@requestClient[type] url:link, callback

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