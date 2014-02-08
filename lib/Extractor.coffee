class Extractor
	constructor: (@cheerio, @baseUrl, @url)->

	create_target: (link, type) -> {link: @_resolve(link), type}
	
	_link_clearer: (link) ->
		return false if link.match(/(^javascript)|(^mailto)\:/)
		link.replace(/\#.*/, '')

	_resolve: (link) -> @url.resolve @baseUrl, link

	_is_internal: (link) ->
		@_resolve(link).indexOf(@baseUrl) > -1 if link
		

	_get_targets: (body) -> @cheerio.load(body)('a, img, script, link')
	
	_get_req: (target) ->

		switch target.name

			when 'a'

				type = if @_is_internal(target.attribs.href) is yes then 'get' else 'head'
				link = target.attribs.href
			
			when 'img'
				type =  'head'
				link =  target.attribs.src

			when 'script'
				type =  'head'
				link =  target.attribs.src
			when 'link'
				type =  'head'
				link =  target.attribs.href
		
		if link and ref = @_link_clearer link
			@create_target(ref, type)
	
	_extract: (body)->  (@_get_req i for i in @_get_targets body)
	
	extract: (body) -> @_extract body

module.exports = Extractor	