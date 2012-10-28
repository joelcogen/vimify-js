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
  vimify.initJko opts
  vimify.initComment opts
  vimify.initSearch opts

  if !(opts["help"] == false)
    console.log "Help: not yet implemented"

vimify.hasManyItems = ->
  $(vimify.selectors.item).length > 1
