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
    store: (thing, onSuccess, onError) ->
      _Annie.thing.store thing, onSuccess, onError

  # TODO need refactor
  settings:
    baseUrlKey: 'annie-base-url'
    
    saveBaseUrl: (baseUrl, cb) ->
      Sync.set @baseUrlKey, baseUrl, cb
      Annie.init()

    getBaseUrl: (cb) ->
      Sync.get @baseUrlKey, cb


root.Annie = AnnieModule
