vimify.search =
  init: (opts) ->
    if opts["search"]
      vimify.selectors.search = opts["search"]
      vimify.register "s", @s, "Search"
      if opts["advancedKeys"]
        vimify.registerAlias "/", "s"

  s: ->
    search = $(vimify.selectors.search)
    $(window).scrollTop(search.offset().top - 20)
    search.focus()
