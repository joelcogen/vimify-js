vimify.initSearch = (opts) ->
  if opts["search"]
    vimify.selectors.search = opts["search"]
    keypress.combo "s", vimify.s
    if opts["advancedKeys"]
      keypress.combo "/", vimify.s

vimify.s = ->
  search = $(vimify.selectors.search)
  $(window).scrollTop(search.offset().top - 20)
  search.focus()
