annieSettings =
  
  baseUrlKey: 'annie-base-url'
  
  $el: null

  save: ($el) ->
    @set$El $el
    Annie.settings.saveBaseUrl @getBaseUrlValue()

  restore: ($el) ->
    @set$El $el
    Annie.settings.getBaseUrl (url) => @setBaseUrlValue(url)

  set$El: (@$el) ->

  getBaseUrlValue: ->
    $baseUrl = @$el.find 'input[name="base-url"]'
    return $baseUrl.val() if $baseUrl?

  setBaseUrlValue: (url) ->
    url = '' unless url?
    $baseUrl = @$el.find 'input[name="base-url"]'
    $baseUrl.val(url) if $baseUrl?


settings =
  annie: annieSettings


getSettingEl = (settingName) ->
  ($ ".settings-block[data-settings-group=\"#{settingName}\"]")



saveSettings = ->
  for key, module of settings
    $el = getSettingEl key
    module.save $el


restoreSettings = ->
  for key, module of settings
    $el = getSettingEl key
    module.restore $el


($ document).ready restoreSettings

$confirmEl = (getSettingEl 'confirm')
$saveBtn = $confirmEl.find 'button[name="save"]'
$discardBtn = $confirmEl.find 'button[name="discard"]'

$saveBtn.click (e) ->
  e.preventDefault()
  saveSettings()

$discardBtn.click (e) ->
  e.preventDefault()
  restoreSettings()
