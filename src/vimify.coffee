window.vimify = {}

# Opts:
# item: selector for each item, required for j, k and o
# item_link: selector for item link (relative to item), required for o
# next_page: selector for the next page link, required for j, default: [rel=next]
# prev_page: selector for the previous page link, required for k, default: [rel=prev]
# search: selector for the search input, required for / and s
vimify.init = (opts = {}) ->
  vimify.selectors = {}
  if opts["item"]
    vimify.selectors.item = opts["item"]
    vimify.selectors.next_page = opts["next_page"]
    vimify.selectors.prev_page = opts["prev_page"]
    keypress.combo "j", vimify.j
    keypress.combo "k", vimify.k
    if opts["item_link"]
      vimify.selectors.item_link = opts["item_link"]
      keypress.combo "o", vimify.o
    # Go to initial position if we come from other page
    if window.location.hash == "#first"
      $(window).load ->
        vimify.j()
    else if window.location.hash == "#last"
      $(window).load ->
        $(window).scrollTop $(vimify.selectors.item).last().offset().top
  if opts["search"]
    vimify.selectors.search = opts["search"]
    keypress.combo "/, s", vimify.s

# Finders
vimify.current_item = ->
  current = null
  items = $(vimify.selectors.item).sort (a, b) ->
    $(a).offset().top < $(b).offset().top
  items.each (_, item) ->
    item = $(item)
    current ||= item if item.offset().top <= $(window).scrollTop()
  current

vimify.next_item = ->
  current = vimify.current_item()
  if current
    current.next(vimify.selectors.item)
  else
    $(vimify.selectors.item).first()

vimify.previous_item = ->
  current = vimify.current_item()
  if current == null || current.offset().top < $(window).scrollTop() - 50
    current
  else
    current.prev()

vimify.next_page_link = ->
  if vimify.selectors.next_page
    $(vimify.selectors.next_page)
  else
    $("[rel=next]")

vimify.prev_page_link = ->
  if vimify.selectors.prev_page
    $(vimify.selectors.prev_page)
  else
    $("[rel=prev]")

# Key functions
vimify.j = ->
  next = vimify.next_item()
  if next.length > 0
    $(window).scrollTop next.offset().top
  else
    link = vimify.next_page_link()
    if link.length > 0
      window.location = link.attr("href") + "#first"
    else
      $(window).scrollTop $(document).height()

vimify.k = ->
  prev = vimify.previous_item()
  if prev && prev.length > 0
    $(window).scrollTop prev.offset().top
  else
    link = vimify.prev_page_link()
    if link.length > 0
      window.location = link.attr("href") + "#last"
    else
      $(window).scrollTop 0

vimify.o = ->
  link = vimify.current_item().find vimify.selectors.item_link
  window.location = link.attr "href"

vimify.s = ->
  $(vimify.selectors.search).focus()
