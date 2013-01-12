vimify.jko =
  init: (opts) ->
    if opts["item"]
      vimify.selectors.item = opts["item"]
      vimify.selectors.nextPage = opts["nextPage"]
      vimify.selectors.prevPage = opts["prevPage"]
      vimify.register "j", @j, "Next item"
      vimify.register "k", @k, "Previous item"
      if opts["simpleKeys"]
        vimify.registerAlias "down", "j"
        vimify.registerAlias "up", "k"
      if opts["itemLink"]
        vimify.selectors.itemLink = opts["itemLink"]
        vimify.register "o", @o, "Open item"
        if opts["simpleKeys"]
          vimify.registerAlias "enter", "o"
      # Go to initial position if we come from other page
      @loadToFirstOrLast()

  # Finders
  nextItem: ->
    current = vimify.currentItem()
    if current
      current.next(vimify.selectors.item)
    else
      $(vimify.selectors.item).first()

  previousItem: ->
    current = vimify.currentItem()
    if current == null || current.offset().top < $(window).scrollTop() - 50
      current
    else
      current.prev()

  nextPageLink: ->
    if vimify.selectors.nextPage
      $(vimify.selectors.nextPage)
    else
      $("[rel=next]")

  prevPageLink: ->
    if vimify.selectors.prevPage
      $(vimify.selectors.prevPage)
    else
      $("[rel=prev]")

  # Helpers
  loadToFirstOrLast: ->
    if window.location.hash == "#first"
      $ ->
        $(window).scrollTop $(vimify.selectors.item).first().offset().top
    else if window.location.hash == "#last"
      $ ->
        $(window).scrollTop $(vimify.selectors.item).last().offset().top

  # Key functions
  j: ->
    return unless vimify.hasManyItems()
    next = vimify.jko.nextItem()
    if next.length > 0
      $(window).scrollTop next.offset().top
    else
      link = vimify.jko.nextPageLink()
      if link.length > 0
        window.location = link.attr("href") + "#first"
      else
        $(window).scrollTop $(document).height()

  k: ->
    return unless vimify.hasManyItems()
    prev = vimify.jko.previousItem()
    if prev && prev.length > 0
      $(window).scrollTop prev.offset().top
    else
      link = vimify.jko.prevPageLink()
      if link.length > 0
        window.location = link.attr("href") + "#last"
      else
        $(window).scrollTop 0

  o: ->
    return unless vimify.hasManyItems()
    if current = vimify.currentItem()
      link = current.find vimify.selectors.itemLink
      window.location = link.attr "href"
