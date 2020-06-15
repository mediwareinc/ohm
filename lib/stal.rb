require "json"

module Stal
  LUA = File.expand_path("../ohm/lua/stal.lua", __FILE__)
  SHA = ENV["REDIS_SHA"]

  # Evaluate expression `expr` in the Redis client `c`.
  # Override #solve in order to use Redis-rb
  def self.solve(c, sha, expr)
    begin
      opts = JSON.dump(expr)
      c.call!("EVALSHA", sha, [], [opts])
    rescue RuntimeError
      if $!.message["NOSCRIPT"]
        #c.call!("SCRIPT", "FLUSH")
        c.call!("SCRIPT", "LOAD", File.read(LUA))
        opts = JSON.dump(expr)
        c.call!("EVALSHA", sha, [], [opts])
      else
        raise $!
      end
    end
  end
end

