vimify.initJko = (opts) ->
  if opts["item"]
    vimify.selectors.item = opts["item"]
    vimify.selectors.nextPage = opts["nextPage"]
    vimify.selectors.prevPage = opts["prevPage"]
    vimify.register "j", vimify.j, "Next item"
    vimify.register "k", vimify.k, "Previous item"
    if opts["simpleKeys"]
      vimify.registerAlias "down", "j"
      vimify.registerAlias "up", "k"
    if opts["itemLink"]
      vimify.selectors.itemLink = opts["itemLink"]
      vimify.register "o", vimify.o, "Open item"
      if opts["simpleKeys"]
        vimify.registerAlias "enter", "o"
    # Go to initial position if we come from other page
    vimify.loadToFirstOrLast()

# Finders
vimify.currentItem = ->
  current = null
  items = $(vimify.selectors.item).sort (a, b) ->
    $(a).offset().top < $(b).offset().top

  # Already scolled to bottom
  return items.first() if $(document).height() - $(window).height() == $(window).scrollTop()

  items.each (_, item) ->
    item = $(item)
    current ||= item if item.offset().top <= $(window).scrollTop()
  current

vimify.nextItem = ->
  current = vimify.currentItem()
  if current
    current.next(vimify.selectors.item)
  else
    $(vimify.selectors.item).first()

vimify.previousItem = ->
  current = vimify.currentItem()
  if current == null || current.offset().top < $(window).scrollTop() - 50
    current
  else
    current.prev()

vimify.nextPageLink = ->
  if vimify.selectors.nextPage
    $(vimify.selectors.nextPage)
  else
    $("[rel=next]")

vimify.prevPageLink = ->
  if vimify.selectors.prevPage
    $(vimify.selectors.prevPage)
  else
    $("[rel=prev]")

# Helpers
vimify.loadToFirstOrLast = ->
  if window.location.hash == "#first"
    $ ->
      $(window).scrollTop $(vimify.selectors.item).first().offset().top
  else if window.location.hash == "#last"
    $ ->
      $(window).scrollTop $(vimify.selectors.item).last().offset().top

# Key functions
vimify.j = (e) ->
  return unless vimify.hasManyItems()
  e.preventDefault()
  next = vimify.nextItem()
  if next.length > 0
    $(window).scrollTop next.offset().top
  else
    link = vimify.nextPageLink()
    if link.length > 0
      window.location = link.attr("href") + "#first"
    else
      $(window).scrollTop $(document).height()

vimify.k = (e) ->
  return unless vimify.hasManyItems()
  e.preventDefault()
  prev = vimify.previousItem()
  if prev && prev.length > 0
    $(window).scrollTop prev.offset().top
  else
    link = vimify.prevPageLink()
    if link.length > 0
      window.location = link.attr("href") + "#last"
    else
      $(window).scrollTop 0

vimify.o = (e) ->
  return unless vimify.hasManyItems()
  e.preventDefault()
  link = vimify.currentItem().find vimify.selectors.itemLink
  window.location = link.attr "href"
