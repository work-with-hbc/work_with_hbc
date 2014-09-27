root = exports ? window


LocalStorage =

  prefix: 'work_with_hbc_'

  set: (id, thing, cb) ->
    localStorage[@getId(id)] = @pack thing
    cb() if cb?

  get: (id, cb) ->
    packed = localStorage[@getId(id)]
    cb @unpack packed if packed?

  remove: (id, cb) ->
    delete localStorage[@getId(id)]
    cb() if cb?

  getId: (id) ->
    "#{@prefix}#{id}"

  pack: (thing) ->
    JSON.stringify thing

  unpack: (packed) ->
    JSON.parse packed


ChromeSync =

  prefix: 'work_with_hbc_'

  set: (id, thing, cb) ->
    if not cb?
      cb = -> Logger.info "#{id} synced"
    
    packed = @pack id, thing
    chrome.storage.sync.set packed, cb

  get: (id, cb) ->
    return unless cb?

    chrome.storage.sync.get @getId(id), (packed) =>
      return unless packed?
      thing = @unpack id, packed
      cb thing if thing?

  remove: (id, cb) ->
    chrome.storage.sync.remove [@getId(id)], cb

  getId: (id) ->
    "#{@prefix}#{id}"

  pack: (id, thing) ->
    thingEncoded = if thing? then JSON.stringify thing else null
    
    rv = {}
    rv[@getId(id)] = thingEncoded

    rv

  unpack: (id, packed) ->
    return unless packed[@getId(id)]?

    JSON.parse packed[@getId(id)]

Sync =

  setProviders: [ChromeSync, LocalStorage]

  getProvider: ChromeSync

  set: (id, thing, cb) ->
    provider.set id, thing, cb for provider in @setProviders

  get: (id, cb) ->
    @getProvider.get id, cb

  remove: (id, cb) ->
    provider.remove id, cb for provider in @setProviders


root.Sync = Sync
