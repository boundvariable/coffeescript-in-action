
exports.fact = (description, fn) ->
  try
    fn()
    console.log "#{description}: OK"
  catch e
    console.log "#{description}: \n#{e.stack}"

