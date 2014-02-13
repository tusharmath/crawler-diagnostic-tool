suite 'Requestor', ->
	
	Requestor = require '../lib/Requestor'	

	test '_request simple calling', ->
		e = new Requestor get: ->
		e._request link: 'sample-link', type: 'get'

	test '_request must throw an error', ->
		e = new Requestor
		e._request.bind(null, type: ->).should.throw 'Target.type should be get or head'

	test '_fetch', ->
		e = new Requestor 'sample-type': ->
		e._fetch 'sample-link', 'sample-type', 'sample-callback'
		e._fetch.bind(null).should.throw('link, type, callback are all required')
	
	test '_onResponse', (done)->
		e = new Requestor 'sample-request'
		e.setContext me: 'tushar'
		e._onResponse 'sample-error', 'sample-response', ->
			this.me.should.equal 'tushar'
			done()
