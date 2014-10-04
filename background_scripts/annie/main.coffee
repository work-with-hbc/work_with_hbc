root = exports ? window

_Annie = Annie


AnnieModule =

  init: ->
    @settings.getBaseUrl (url) ->
      return unless url?
      Logger.info "setting annie with base url #{url}"
      _Annie.setBaseUrl url

  thing:
    get: (id, onSuccess, onError) ->
      _Annie.thing.get id, onSuccess, onError
    getList: (id, onSuccess, onError) ->
      _Annie.thing.getList id, onSuccess, onError
    store: (thing, onSuccess, onError) ->
      _Annie.thing.store thing, onSuccess, onError
    storeWithId: (id, thing, onSuccess, onError) ->
      _Annie.thing.storeWithId id, thing, onSuccess, onError
    storeList: (things, onSuccess, onError) ->
      _Annie.thing.storeList things, onSuccess, onError
    storeListWithId: (id, things, onSuccess, onError) ->
      _Annie.thing.storeListWithId id, things, onSuccess, onError
    pushThingToList: (id, thing, onSuccess, onError) ->
      _Annie.pushThingToList id, thing, onSuccess, onError

  # TODO need refactor
  settings:
    baseUrlKey: 'annie-base-url'
    
    saveBaseUrl: (baseUrl, cb) ->
      Sync.set @baseUrlKey, baseUrl, cb
      Annie.init()

    getBaseUrl: (cb) ->
      Sync.get @baseUrlKey, cb


root.Annie = AnnieModule
