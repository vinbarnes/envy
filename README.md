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

TODO
API:
- convert from instance to class (Envy.get, Envy.set instead of @envy.get, etc)

Testing inserts a proxy instance that:
- overrides/shadows actual keys/values
- raises when setting a key/value that is not currently set
- key/value pairs can be set "globally" in test helper config or
  locally per test file or indvidually in each test
