
window.vimify = {};

vimify.init = function(opts) {
  if (opts == null) {
    opts = {};
  }
  vimify.selectors = {};
  vimify.registeredKeys = {};
  vimify.initJko(opts);
  vimify.initComment(opts);
  vimify.initSearch(opts);
  return vimify.initHelp(opts);
};

vimify.register = function(key, fn, help) {
  vimify.registeredKeys[key] = {
    keys: [key],
    fn: fn,
    help: help
  };
  return keypress.combo(key, fn);
};

vimify.registerAlias = function(aliasKey, realKey) {
  var keyData;
  keyData = vimify.registeredKeys[realKey];
  keyData.keys.push(aliasKey);
  return keypress.combo(aliasKey, keyData.fn);
};

vimify.hasManyItems = function() {
  return $(vimify.selectors.item).length > 1;
};


vimify.initComment = function(opts) {
  if (opts["comment"]) {
    vimify.selectors.comment = opts["comment"];
    keypress.combo("c", vimify.c);
    if (opts["advancedKeys"]) {
      return keypress.combo("i", vimify.c);
    }
  }
};

vimify.loadToComment = function() {
  if (window.location.hash === "#comment") {
    return $(window).load(function() {
      return vimify.focusComment();
    });
  }
};

vimify.focusComment = function() {
  var comment;
  comment = $(vimify.selectors.comment);
  $(window).scrollTop(comment.offset().top - 20);
  return comment.focus();
};

vimify.c = function() {
  var link;
  if (vimify.hasManyItems()) {
    link = vimify.currentItem().find(vimify.selectors.itemLink);
    return window.location = link.attr("href") + "#comment";
  } else {
    return vimify.focusComment();
  }
};


vimify.initHelp = function(opts) {
  if (opts["help"] === false) {
    return;
  }
  keypress.combo("h", vimify.h);
  if (opts["advancedKeys"]) {
    return keypress.combo("?", vimify.h);
  }
};

vimify.h = function() {
  if ($(".vimify-help").length > 0) {
    vimify.closeHelp();
    return;
  }
  $("body").append("<div class=\"vimify-help-backdrop\"></div>");
  $("body").append(vimify.buildHelp());
  return keypress.combo("escape", vimify.closeHelp);
};

vimify.closeHelp = function() {
  $(".vimify-help, .vimify-help-backdrop").remove();
  return keypress.unregister_combo({
    keys: "escape"
  });
};

vimify.buildHelp = function() {
  var entry, helpDiv, replacements, _, _ref;
  replacements = {
    down: "▼",
    up: "▲",
    enter: "⏎"
  };
  helpDiv = "<div class=\"vimify-help\">";
  helpDiv += "<div class=\"vimify-help-entry .vimify-help-title\">Keyboard shortcuts</div>";
  _ref = vimify.registeredKeys;
  for (_ in _ref) {
    entry = _ref[_];
    helpDiv += "<div class=\"vimify-help-entry\">";
    helpDiv += entry.keys.map(function(key) {
      if (replacements[key] != null) {
        key = replacements[key];
      }
      return "<div class=\"vimify-help-key\">" + key + "</div>";
    }).reduce(function(a, b) {
      return "" + a + " / " + b;
    });
    helpDiv += "<div class=\"vimify-help-message\">" + entry.help + "</div>";
    helpDiv += "</div>";
  }
  return helpDiv += "</div>";
};


vimify.initJko = function(opts) {
  if (opts["item"]) {
    vimify.selectors.item = opts["item"];
    vimify.selectors.nextPage = opts["nextPage"];
    vimify.selectors.prevPage = opts["prevPage"];
    vimify.register("j", vimify.j, "Next item");
    vimify.register("k", vimify.k, "Previous item");
    if (opts["simpleKeys"]) {
      vimify.registerAlias("down", "j");
      vimify.registerAlias("up", "k");
    }
    if (opts["itemLink"]) {
      vimify.selectors.itemLink = opts["itemLink"];
      vimify.register("o", vimify.o, "Open item");
      if (opts["simpleKeys"]) {
        vimify.registerAlias("enter", "o");
      }
    }
    return vimify.loadToFirstOrLast();
  }
};

vimify.currentItem = function() {
  var current, items;
  current = null;
  items = $(vimify.selectors.item).sort(function(a, b) {
    return $(a).offset().top < $(b).offset().top;
  });
  items.each(function(_, item) {
    item = $(item);
    if (item.offset().top <= $(window).scrollTop()) {
      return current || (current = item);
    }
  });
  return current;
};

vimify.nextItem = function() {
  var current;
  current = vimify.currentItem();
  if (current) {
    return current.next(vimify.selectors.item);
  } else {
    return $(vimify.selectors.item).first();
  }
};

vimify.previousItem = function() {
  var current;
  current = vimify.currentItem();
  if (current === null || current.offset().top < $(window).scrollTop() - 50) {
    return current;
  } else {
    return current.prev();
  }
};

vimify.nextPageLink = function() {
  if (vimify.selectors.nextPage) {
    return $(vimify.selectors.nextPage);
  } else {
    return $("[rel=next]");
  }
};

vimify.prevPageLink = function() {
  if (vimify.selectors.prevPage) {
    return $(vimify.selectors.prevPage);
  } else {
    return $("[rel=prev]");
  }
};

vimify.loadToFirstOrLast = function() {
  if (window.location.hash === "#first") {
    return $(window).load(function() {
      return $(window).scrollTop($(vimify.selectors.item).first().offset().top);
    });
  } else if (window.location.hash === "#last") {
    return $(window).load(function() {
      return $(window).scrollTop($(vimify.selectors.item).last().offset().top);
    });
  }
};

vimify.j = function(e) {
  var link, next;
  if (!vimify.hasManyItems()) {
    return;
  }
  e.preventDefault();
  next = vimify.nextItem();
  if (next.length > 0) {
    return $(window).scrollTop(next.offset().top);
  } else {
    link = vimify.nextPageLink();
    if (link.length > 0) {
      return window.location = link.attr("href") + "#first";
    } else {
      return $(window).scrollTop($(document).height());
    }
  }
};

vimify.k = function(e) {
  var link, prev;
  if (!vimify.hasManyItems()) {
    return;
  }
  e.preventDefault();
  prev = vimify.previousItem();
  if (prev && prev.length > 0) {
    return $(window).scrollTop(prev.offset().top);
  } else {
    link = vimify.prevPageLink();
    if (link.length > 0) {
      return window.location = link.attr("href") + "#last";
    } else {
      return $(window).scrollTop(0);
    }
  }
};

vimify.o = function(e) {
  var link;
  if (!vimify.hasManyItems()) {
    return;
  }
  e.preventDefault();
  link = vimify.currentItem().find(vimify.selectors.itemLink);
  return window.location = link.attr("href");
};


vimify.initSearch = function(opts) {
  if (opts["search"]) {
    vimify.selectors.search = opts["search"];
    keypress.combo("s", vimify.s);
    if (opts["advancedKeys"]) {
      return keypress.combo("/", vimify.s);
    }
  }
};

vimify.s = function() {
  var search;
  search = $(vimify.selectors.search);
  $(window).scrollTop(search.offset().top - 20);
  return search.focus();
};