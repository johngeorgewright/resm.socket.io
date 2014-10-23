MESSAGES =
  0: 'Internal Error'
  3: 'Service Unvailable'
  7: 'Insufficient Storage'
  8: 'Loop Detected'

class ProcessingError extends Error
  (@code = 0)->
    msg = if MESSAGES[code]? then MESSAGES[code] else 'Unknown Error'
    super msg

module.exports = ProcessingError

