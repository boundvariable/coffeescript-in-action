
success = 0
failure = 0

exports.fact = (description, fn) ->
  try
    fn()
    success++
    console.log "#{description}: OK"
  catch e
    console.error "#{description}: "
    throw e


exports.report = (suite) ->
  console.log """
  -------------------------------------------------------------------
  #{suite} finished with #{success} successes and #{failure} failures
  -------------------------------------------------------------------
  """