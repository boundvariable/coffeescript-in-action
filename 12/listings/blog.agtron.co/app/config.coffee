# The production config host needs to be replaced
# with a host that you have shell access to.

config =
  development:
    host: 'localhost'
    port: '8080'
  production:
    host: 'xx.agtron.co'
    port: '8888'

for key, value of config
  exports[key] = value
