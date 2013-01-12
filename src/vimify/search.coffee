vimify.initSearch = (opts) ->
  if opts["search"]
    vimify.selectors.search = opts["search"]
    vimify.register "s", vimify.s, "Search"
    if opts["advancedKeys"]
      vimify.registerAlias "/", "s"

vimify.s = ->
  search = $(vimify.selectors.search)
  $(window).scrollTop(search.offset().top - 20)
  search.focus()
