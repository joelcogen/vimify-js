window.vimify = {}

# Opts:
# Selectors:
# item: selector for each item, required for j, k and o
# itemLink: selector for item link (relative to item), required for o
# nextPage: selector for the next page link, required for j, default: [rel=next]
# prevPage: selector for the previous page link, required for k, default: [rel=prev]
# search: selector for the search input, required for s
# comment: selector for the comment inpit, required for c
# Boolean options:
# simpleKeys: enable simple keys (up, down, enter)
# advancedKeys: enable advance keys (/ to search, i to comment, ? for help)
# help: enable help (h), true by default
vimify.init = (opts = {}) ->
  vimify.selectors = {}
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

  if opts["search"]
    vimify.selectors.search = opts["search"]
    keypress.combo "s", vimify.s
    if opts["advancedKeys"]
      keypress.combo "/", vimify.s

  if opts["comment"]
    vimify.selectors.comment = opts["comment"]
    keypress.combo "c", vimify.c
    if opts["advancedKeys"]
      keypress.combo "i", vimify.c

  if !(opts["help"] == false)
    console.log "Help: not yet implemented"

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

vimify.hasManyItems = ->
  $(vimify.selectors.item).length > 1

# Helpers
vimify.loadToFirstOrLast = ->
  if window.location.hash == "#first"
    $(window).load ->
      vimify.j()
  else if window.location.hash == "#last"
    $(window).load ->
      $(window).scrollTop $(vimify.selectors.item).last().offset().top

vimify.loadToComment = ->
  if window.location.hash == "#comment"
    $(window).load ->
      vimify.focusComment()

vimify.focusComment = ->
  comment = $(vimify.selectors.comment)
  $(window).scrollTop(comment.offset().top - 20)
  comment.focus()

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

vimify.s = ->
  search = $(vimify.selectors.search)
  $(window).scrollTop(search.offset().top - 20)
  search.focus()

vimify.c = ->
  if vimify.hasManyItems()
    link = vimify.currentItem().find vimify.selectors.itemLink
    window.location = link.attr("href") + "#comment"
  else
    vimify.focusComment()
