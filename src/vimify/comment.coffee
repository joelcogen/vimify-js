vimify.initComment = (opts) ->
  if opts["comment"]
    vimify.selectors.comment = opts["comment"]
    vimify.register "c", vimify.c, "Comment"
    if opts["advancedKeys"]
      vimify.registerAlias "i", "c"
    vimify.loadToComment()

vimify.loadToComment = ->
  if window.location.hash == "#comment"
    $ ->
      vimify.focusComment()

vimify.focusComment = ->
  comment = $(vimify.selectors.comment)
  $(window).scrollTop(comment.offset().top - 20)
  comment.focus()

vimify.c = (e) ->
  if vimify.hasManyItems()
    link = vimify.currentItem().find vimify.selectors.itemLink
    window.location = link.attr("href") + "#comment"
  else
    vimify.focusComment()
