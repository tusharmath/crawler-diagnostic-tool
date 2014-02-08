suite 'Extractor', ->
	Extractor = require '../lib/Extractor'

	test 'create_target', ->
		e = new Extractor {}, 'sample-base-url', resolve:->
		e.create_target()
 
	test '_get_targets', ->
		cheerio = load : (body) -> (x)-> x + body
		e = new Extractor cheerio
		e._get_targets('-aaa').should.equal 'a, img, script, link-aaa'