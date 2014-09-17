root = exports ? window

Utils =
  # Creates a single DOM element from :html
  createElementFromHtml: (html) ->
    tmp = document.createElement("div")
    tmp.innerHTML = html
    tmp.firstChild

root.Utils = Utils
