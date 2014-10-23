MESSAGES =
  0: 'Bad Request'
  1: 'Unauthorized'
  2: 'Payment Required'
  3: 'Forbidden'
  4: 'Not Found'
  5: 'Message Type Not Allowed'
  9: 'Conflict'
  10: 'Gnoe'
  12: 'Precondition Failed'
  15: 'Unsupported Media Type'
  19: 'Authentication Timeout'
  22: 'Unprocessable Entity'
  23: 'Locked'
  24: 'Failed Dependency'
  25: 'Upgrade Required'
  28: 'Precondition Required'
  29: 'Too Many Requests'
  51: 'Unavailable For Legal Reasons'

class RequestError extends Error
  (@code = 0)->
    msg = if MESSAGES[code]? then MESSAGES[code] else 'Unknown Error'
    super msg

module.exports = RequestError

