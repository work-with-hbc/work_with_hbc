root = exports ? window

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  console.log 'here'
  false
