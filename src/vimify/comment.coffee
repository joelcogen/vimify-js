vimify.initComment = (opts) ->
  if opts["comment"]
    vimify.selectors.comment = opts["comment"]
    keypress.combo "c", vimify.c
    if opts["advancedKeys"]
      keypress.combo "i", vimify.c

vimify.loadToComment = ->
  if window.location.hash == "#comment"
    $(window).load ->
      vimify.focusComment()

vimify.focusComment = ->
  comment = $(vimify.selectors.comment)
  $(window).scrollTop(comment.offset().top - 20)
  comment.focus()

vimify.c = ->
  if vimify.hasManyItems()
    link = vimify.currentItem().find vimify.selectors.itemLink
    window.location = link.attr("href") + "#comment"
  else
    vimify.focusComment()
