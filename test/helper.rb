begin
  require "ruby-debug"
rescue LoadError
end

require "cutest"
require "pry"

def silence_warnings
  original_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = original_verbose
end unless defined?(silence_warnings)

$VERBOSE = true

require_relative "../lib/ohm"

Ohm.redis = Redic.new("redis://127.0.0.1:6379")
Ohm.redis_sha = "test"

prepare do
  Ohm.redis.call("FLUSHALL")
end
