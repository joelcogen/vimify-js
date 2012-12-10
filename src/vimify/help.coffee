vimify.initHelp = (opts) ->
  return if opts["help"] == false
  keypress.combo "h", vimify.h
  if opts["advancedKeys"]
    keypress.combo "?", vimify.h

vimify.h = ->
  if $(".vimify-help").length > 0
    vimify.closeHelp()
    return
  $("body").append "<div class=\"vimify-help-backdrop\"></div>"
  $("body").append vimify.buildHelp()
  keypress.combo "escape", vimify.closeHelp

vimify.closeHelp = ->
  $(".vimify-help, .vimify-help-backdrop").remove()
  keypress.unregister_combo
    keys: "escape"

vimify.buildHelp = ->
  replacements = { down: "▼", up: "▲", enter: "⏎" }
  helpDiv = "<div class=\"vimify-help\">"
  helpDiv += "<div class=\"vimify-help-entry .vimify-help-title\">Keyboard shortcuts</div>"
  for _, entry of vimify.registeredKeys
    helpDiv += "<div class=\"vimify-help-entry\">"
    helpDiv += entry.keys.map (key) ->
      key = replacements[key] if replacements[key]?
      "<div class=\"vimify-help-key\">#{key}</div>"
    .reduce (a, b) ->
      "#{a} / #{b}"
    helpDiv += "<div class=\"vimify-help-message\">#{entry.help}</div>"
    helpDiv += "</div>"
  helpDiv += "</div>"

