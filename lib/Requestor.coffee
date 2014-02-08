class Requestor
	constructor: (@requestClient)->

	setContext: (@context) ->
	
	_fetch: (link, type, callback) ->
		@requestClient[type] link, callback

	_onResponse: (error, response, callback, target) ->
		callback.call @context, error, response, target
	
	_request: (target, callback) ->

		@_fetch target.link, target.type, (error, response) =>
			@_onResponse error, response, callback, target

	request: (target, callback) ->
		@_request target, callback


module.exports = Requestor