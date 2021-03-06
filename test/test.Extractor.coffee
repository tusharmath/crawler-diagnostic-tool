suite 'Extractor', ->
	Extractor = require '../lib/Extractor'
	url = require 'url'
	test 'create_target simple call', ->
		e = new Extractor null, null, resolve: (a,b)-> a+b
		target = e.create_target('sample-base-url', 'sample-base-link', 'get')
		target.link.should.equal 'sample-base-urlsample-base-link'
		target.parentLink.should.equal 'sample-base-url'
		target.type.should.equal 'get'

	test 'create_target should not accept empty types', ->
		e = new Extractor
		e.create_target.bind(e, 'sample-base-url', 'sample-link').should.throw 'Targets can not be created without a type'

	test 'extract', ->
		e = new Extractor
		e.extract.bind().should.throw 'Can not extract without a parent link'

	test '_is_internal', ->
		e = new Extractor null, 'carbon-di-oxide', resolve: (a,b)-> a+b
		e._is_internal('sample-base-url', 'sample-link').should.not.be.ok
		e._is_internal('carbon-di-oxide-sample-url', 'sample-link').should.be.ok
		e._is_internal('sample-base-url', 'sample-carbon-di-oxide-link').should.not.be.ok
	
	
	test '_resolve', ->
		e = new Extractor null, null, url
		e._resolve('http://tusharm.com/articles/apple-passbook-indian-airports/', '/articles/apple-passbook-indian-airports/snapshot.png').should.equal 'http://tusharm.com/articles/apple-passbook-indian-airports/snapshot.png'
		e._resolve('http://tusharm.com/articles/geocode-your-life/', '3.jpg').should.equal('http://tusharm.com/articles/geocode-your-life/3.jpg');


	test '_get_targets', ->
		cheerio = load : (body) -> (x)-> x + body
		e = new Extractor cheerio
		e._get_targets('-aaa').should.equal 'a, img, script, link-aaa'