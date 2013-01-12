# Vimify

Easily add keyboard shortcuts to your website to make it faster to navigate

## Setup

Copy `vimify.js` and `vimify.css` or the minified versions from the `dist` directory to your site, then call:

    vimify.init({
      item: 'article',
      itemLink: 'h1 a',
      comment: "#new-comment",
      search: ".search input"
    });
  
Vimify requires [jQuery 1.8](http://jquery.com/download/)

`vimify.css` is only required to display the help, so you can skip it if you plan on disabling the help feature or on writing your own help styles.

## Options

`vimify.init` accepts the following options:

* `item`: selector for each item, required for __j__, __k__ and __o__
* `itemLink`: selector for item link (relative to item), required for __o__
* `nextPage`: selector for the next page link, required for __j__, default: `[rel=next]`
* `prevPage`: selector for the previous page link, required for __k__, default: `[rel=prev]`
* `search`: selector for the search input, required for __s__
* `comment`: selector for the comment inpit, required for __c__
* `simpleKeys`: enable simple keys (up, down, enter)
* `advancedKeys`: enable advance keys (/ to search, i to comment)
* `help`: enable help (h), `true` by default

You can check out the [demo](https://github.com/joelcogen/vimify-js/tree/master/demo) if you are unsure of what options to use.
