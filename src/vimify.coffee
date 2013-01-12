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
# advancedKeys: enable advance keys (/ to search, i to comment)
# help: enable help (h), true by default
vimify.init = (opts = {}) ->
  vimify.selectors = {}
  vimify.registeredKeys = {}

  vimify.initJko opts
  vimify.initComment opts
  vimify.initSearch opts
  vimify.initHelp opts

  $(document).keydown vimify.handleKeydown
  $(document).keyup vimify.handleKeyup

vimify.register = (key, fn, help) ->
  vimify.registeredKeys[key] = { keys: [key], fn: fn, help: help }

vimify.registerAlias = (aliasKey, realKey) ->
  keyData = vimify.registeredKeys[realKey]
  keyData.keys.push aliasKey

vimify.unregister = (key) ->
  delete vimify.registeredKeys[key]

vimify.hasManyItems = ->
  $(vimify.selectors.item).length > 1

vimify.handleKeydown = (e) ->
  e.preventDefault() if vimify.findKey(e)

vimify.handleKeyup = (e) ->
  if fn = vimify.findKey(e)
    e.preventDefault()
    fn()

vimify.findKey = (e) ->
  return false if e.target.tagName in ["INPUT", "TEXTAREA"]
  key = vimify.charcodes[e.which]
  for _, entry of vimify.registeredKeys
    if key in entry.keys
      return entry.fn
  false

vimify.charcodes =
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
