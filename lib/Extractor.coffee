class Extractor
	constructor: (@cheerio, @startUrl, @url)->

	create_target: (baseUrl, link, type) ->
		if type isnt 'get' and type isnt 'head'
			throw new Error 'Targets can not be created without a type'

		{link: @_resolve(baseUrl, link), type}
	
	_link_clearer: (link) ->
		return false if link.match(/(^javascript)|(^mailto)\:/)
		link.replace(/\#.*/, '')

	_resolve: (baseUrl, link) -> 
		if baseUrl is undefined
			throw new Error 'Cannot resolve a url if base url is not defined'
		if link is undefined
			throw new Error 'Cannot resolve a url if link is not defined'
		@url.resolve baseUrl, link

	_is_internal: (baseUrl, link) ->
		@_resolve(baseUrl, link).indexOf(@startUrl) is 0
		

	_get_targets: (body) -> @cheerio.load(body)('a, img, script, link')
	
	_get_req: (target) ->

		switch target.name

			when 'a'
				type = if @_is_internal(target.parent.href, target.attribs.href) is yes then 'get' else 'head'
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
		
		if link and (ref = @_link_clearer(link))
			@create_target target.parent.href, ref, type
	
	_extract: (body)->  (@_get_req i for i in @_get_targets body)
	
	extract: (body) -> @_extract body

module.exports = Extractor