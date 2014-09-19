root = exports ? window

Notification =

  init: ->

  make: (text) ->
    options =
      type: 'basic'
      iconUrl: '../assets/icon.png'
      message: text
      priority: 2
      title: 'Work with hbc'
    
    chrome.notifications.create '', options, (id) ->
      console.debug "notification #{id} created"


root.Notification = Notification
