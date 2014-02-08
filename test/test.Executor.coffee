suite 'Executor', ->
	Executor = require '../lib/Executor'
	
	test 'start', ->
		e = new Executor
		e.extractor = create_target : -> link : 'sample-link'
		e.requestor = request : ->
		e.start()

	test '_request', ->
		e = new Executor

		e.requestor = request: ->
		e._request link: 'sample-link'

	test '_start_target', ->
		e = new Executor
		e.extractor = create_target : -> {}
		e._start_target()

	test '_requestAll', ->

		e= new Executor
		e.extractor = extract:->[]
		e._requestAll body: 'sample-body'

	test '_create_target', ->
		e = new Executor
		e.extractor = create_target : ->
		e._create_target()

	test '_updateLinks', ->
		e = new Executor
		e._updateLinks request:href: 'sample-link'
		e.loadedlinks['sample-link'].should.be.ok
	
	test '_isCrawlable', ->
		e = new Executor
		e._isCrawlable 'sample-link'
		
	test '_onResponse', (done)->
		e = new Executor
		err = {}
		e.onResponseCallback = -> done()
		e._onResponse err, statusCode: 'sample-status-code', {parent: 'sample-parent'}
		
