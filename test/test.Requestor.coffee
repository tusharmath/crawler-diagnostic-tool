suite 'Requestor', ->
	
	Requestor = require '../lib/Requestor'	

	test '_request', ->
		e = new Requestor 'sample-type': ->
		e._request link: 'sample-link', type: 'sample-type'


	test '_fetch', ->
		e = new Requestor 'sample-type': ->
		e._fetch 'sample-link', 'sample-type', 'sample-callback'
	
	test '_onResponse', (done)->
		e = new Requestor 'sample-request'
		e.setContext me: 'tushar'
		e._onResponse 'sample-error', 'sample-response', ->
			this.me.should.equal 'tushar'
			done()
