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
