vimify.comment =
  init: (opts) ->
    if opts["comment"]
      vimify.selectors.comment = opts["comment"]
      vimify.register "c", @c, "Comment"
      if opts["advancedKeys"]
        vimify.registerAlias "i", "c"
      @loadToComment()

  loadToComment: ->
    if window.location.hash == "#comment"
      $ =>
        @focusComment()

  focusComment: ->
    comment = $(vimify.selectors.comment)
    $(window).scrollTop(comment.offset().top - 20)
    comment.focus()

  c: (e) ->
    if vimify.hasManyItems()
      link = vimify.currentItem().find vimify.selectors.itemLink
      window.location = link.attr("href") + "#comment"
    else
      vimify.comment.focusComment()
