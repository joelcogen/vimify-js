
window.vimify = {};

vimify.init = function(opts) {
  if (opts == null) {
    opts = {};
  }
  vimify.selectors = {};
  vimify.initJko(opts);
  vimify.initComment(opts);
  vimify.initSearch(opts);
  if (!(opts["help"] === false)) {
    return console.log("Help: not yet implemented");
  }
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


vimify.initJko = function(opts) {
  if (opts["item"]) {
    vimify.selectors.item = opts["item"];
    vimify.selectors.nextPage = opts["nextPage"];
    vimify.selectors.prevPage = opts["prevPage"];
    keypress.combo("j", vimify.j);
    keypress.combo("k", vimify.k);
    if (opts["simpleKeys"]) {
      keypress.combo("down", vimify.j);
      keypress.combo("up", vimify.k);
    }
    if (opts["itemLink"]) {
      vimify.selectors.itemLink = opts["itemLink"];
      keypress.combo("o", vimify.o);
      if (opts["simpleKeys"]) {
        keypress.combo("enter", vimify.o);
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
      return vimify.j();
    });
  } else if (window.location.hash === "#last") {
    return $(window).load(function() {
      return $(window).scrollTop($(vimify.selectors.item).last().offset().top);
    });
  }
};

vimify.j = function() {
  var link, next;
  if (!vimify.hasManyItems()) {
    return;
  }
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

vimify.k = function() {
  var link, prev;
  if (!vimify.hasManyItems()) {
    return;
  }
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

vimify.o = function() {
  var link;
  if (!vimify.hasManyItems()) {
    return;
  }
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
