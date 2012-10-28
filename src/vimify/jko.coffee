vimify.initJko = (opts) ->
  if opts["item"]
    vimify.selectors.item = opts["item"]
    vimify.selectors.nextPage = opts["nextPage"]
    vimify.selectors.prevPage = opts["prevPage"]
    keypress.combo "j", vimify.j
    keypress.combo "k", vimify.k
    if opts["simpleKeys"]
      keypress.combo "down", vimify.j
      keypress.combo "up", vimify.k
    if opts["itemLink"]
      vimify.selectors.itemLink = opts["itemLink"]
      keypress.combo "o", vimify.o
      if opts["simpleKeys"]
        keypress.combo "enter", vimify.o
    # Go to initial position if we come from other page
    vimify.loadToFirstOrLast()

# Finders
vimify.currentItem = ->
  current = null
  items = $(vimify.selectors.item).sort (a, b) ->
    $(a).offset().top < $(b).offset().top
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
    $(window).load ->
      vimify.j()
  else if window.location.hash == "#last"
    $(window).load ->
      $(window).scrollTop $(vimify.selectors.item).last().offset().top

# Key functions
vimify.j = ->
  return unless vimify.hasManyItems()
  next = vimify.nextItem()
  if next.length > 0
    $(window).scrollTop next.offset().top
  else
    link = vimify.nextPageLink()
    if link.length > 0
      window.location = link.attr("href") + "#first"
    else
      $(window).scrollTop $(document).height()

vimify.k = ->
  return unless vimify.hasManyItems()
  prev = vimify.previousItem()
  if prev && prev.length > 0
    $(window).scrollTop prev.offset().top
  else
    link = vimify.prevPageLink()
    if link.length > 0
      window.location = link.attr("href") + "#last"
    else
      $(window).scrollTop 0

vimify.o = ->
  return unless vimify.hasManyItems()
  link = vimify.currentItem().find vimify.selectors.itemLink
  window.location = link.attr "href"
