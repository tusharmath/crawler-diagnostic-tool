suite 'Crawler', ->
	Crawler = require '../lib/Crawler'
	
	test 'start', ->
		e = new Crawler
		e.extractor = create_target : -> link : 'sample-link'
		e.requestor = request : ->
		e.start()

	test '_request', ->
		e = new Crawler

		e.requestor = request: ->
		e._request link: 'sample-link'

	test '_start_target', ->
		e = new Crawler
		e.extractor = create_target : -> {}
		e._start_target()

	test '_requestAll', ->

		e= new Crawler
		e.extractor = extract:->[]
		e._requestAll body: 'sample-body'

	test '_create_target', ->
		e = new Crawler
		e.extractor = create_target : ->
		e._create_target()

	test '_updateLinks', ->
		e = new Crawler
		e._updateLinks request:href: 'sample-link'
		e.loadedlinks['sample-link'].should.be.ok
	
	test '_isCrawlable', ->
		e = new Crawler
		e._isCrawlable 'sample-link'
		
	test '_onResponse', (done)->
		e = new Crawler
		err = {}
		e.onResponseCallback = -> done()
		e._onResponse err, statusCode: 'sample-status-code', {parent: 'sample-parent'}
		
