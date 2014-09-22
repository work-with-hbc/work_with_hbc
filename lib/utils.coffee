root = exports ? window

Utils =
  # Creates a single DOM element from :html
  createElementFromHtml: (html) ->
    tmp = document.createElement("div")
    tmp.innerHTML = html
    tmp.firstChild

  # Parse datetime offset from natural language.
  #
  # 5 minutes -> 300000
  # 1 second  -> 1000
  # 1 hour    -> 3600000
  humanizeDatetimeOffset: (tongue) ->
    offset =
      millisecond: 1
    offset.second = offset.millisecond * 1000
    offset.minute = offset.second * 60
    offset.hour   = offset.minute * 60
    offset.day    = offset.hour * 24
    offset.month  = offset.day * 30
    offset.year   = offset.month * 12

    unitPattern = ///^ (
      millisecond
    | ms
    | second
    | s
    | minute
    | min
    | hour
    | hr
    | day
    | month
    | year
    | yr
    ) ///

    [times, unit] = tongue.trim().split(' ')[0..1]

    times = parseInt times, 10
    return 0 if isNaN times

    matchedUnit = unitPattern.exec unit
    return 0 unless unit?
    unit = matchedUnit[0]

    return times * offset[unit]

root.Utils = Utils
