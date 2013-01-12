window.vimify =

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
  # advancedKeys: enable advance keys (/ to search, i to comment)
  # help: enable help (h), true by default
  init: (opts = {}) ->
    @selectors = {}
    @registeredKeys = {}

    @jko.init(opts)
    @comment.init(opts)
    @search.init(opts)
    @help.init(opts)

    $(document).keydown @handleKeydown
    $(document).keyup @handleKeyup

  # Finders
  hasManyItems: ->
    $(@selectors.item).length > 1

  currentItem: ->
    current = null
    items = $(@selectors.item).sort (a, b) ->
      $(a).offset().top < $(b).offset().top

    # Already scolled to bottom
    return items.first() if $(document).height() - $(window).height() == $(window).scrollTop()

    items.each (_, item) ->
      item = $(item)
      current ||= item if item.offset().top <= $(window).scrollTop()
    current

  # Key binding registration
  register: (key, fn, help) ->
    @registeredKeys[key] = { keys: [key], fn: fn, help: help }

  registerAlias: (aliasKey, realKey) ->
    keyData = @registeredKeys[realKey]
    keyData.keys.push aliasKey

  unregister: (key) ->
    delete @registeredKeys[key]

  # Key events
  handleKeydown: (e) ->
    e.preventDefault() if vimify.findKey(e)

  handleKeyup: (e) ->
    if fn = vimify.findKey(e)
      e.preventDefault()
      fn()

  findKey: (e) ->
    return false if e.target.tagName in ["INPUT", "TEXTAREA"]
    key = @charcodes[e.which]
    for _, entry of @registeredKeys
      if key in entry.keys
        return entry.fn
    false

  charcodes:
    13  : "enter"
    27  : "escape"
    38  : "up"
    40  : "down"
    67  : "c"
    72  : "h"
    73  : "i"
    74  : "j"
    75  : "k"
    79  : "o"
    83  : "s"
    191 : "/"
