# envy - encapsulate env vars

Small wrapper for accessing env vars.

Instead of
```ruby
key = ENV["API_KEY"]
key = ENV.fetch("API_KEY", "sandbox-key")
```

```ruby
key = Envy["API_KEY"]
key = Envy["API_KEY", "sandbox-key"]
```

This abstraction is useful for testing too:
```ruby
Envy.set("API_KEY", "temp-key") do
  assert behavior
end
```

# = Envy
#
# Envy.get_int("XNUM") # type casts to int using #to_i
# Envy.get_str("XSTR", "tomax") # with default
# Envy.get_bool!("XENABLED") # raises if not set
#
#   @envy = Envy.new do |config|
#
#   end
#
#   Envy.config do |config|
#
#   end
#
# Defaults to @envy = Envy.new(ENV) where ENV is basically a Hash.
#
#   @envy = Envy.new # makes testing easier as well as proxying to ENV[]
#   Envy.parent = @envy # TODO consider better name for "parent"
#   Envy.register :string, "XSTR", default: "tomax"
#   Envy.register :integer, "XNUM", default: 0
#   Envy.register :boolean, "XENABLED", default: true
#
# Here is an example of the raise case taken from Rails: https://github.com/rails/rails/blob/cf2905d77728d718372767f8bdbec0a62e513242/activerecord/lib/active_record/railties/databases.rake#L141
#
#   raise "Empty VERSION provided" if ENV["VERSION"] && ENV["VERSION"].empty?
#
# And here is a case of a typecast: https://github.com/rails/rails/blob/cf2905d77728d718372767f8bdbec0a62e513242/activerecord/lib/active_record/railties/databases.rake#L264
#
#   step = ENV["STEP"] ? ENV["STEP"].to_i : 1
#
# An example of using a default when unset: https://github.com/rails/rails/blob/cf2905d77728d718372767f8bdbec0a62e513242/activerecord/lib/active_record/tasks/postgresql_database_tasks.rb#L8
#
#   DEFAULT_ENCODING = ENV["CHARSET"] || "utf8"


TODO
API:
- convert from instance to class (Envy.get, Envy.set instead of @envy.get, etc)

Testing inserts a proxy instance that:
- overrides/shadows actual keys/values
- raises when setting a key/value that is not currently set
- key/value pairs can be set "globally" in test helper config or
  locally per test file or indvidually in each test
