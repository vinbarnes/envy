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

class Envy
  TYPE_CAST_METHODS = {
    string: :to_s,
    integer: :to_i,
    boolean: :to_bool
  }

  @@config = Hash.new({type: :string, default: nil})

  def self.config
    yield self
  end

  def self._config_hash
    @@config
  end

  def self.string(key, default=nil)
    configure(key, :string, default)
  end

  def self.integer(key, default=nil)
    configure(key, :integer, default)
  end

  def self.boolean(key, default=nil)
    configure(key, :boolean, default)
  end

  def self.configure(key, type=:string, default=nil)
    @@config[key] = {type: type, default: default}
  end

  def environment
    ENV
  end

  def _config_hash
    self.class._config_hash
  end

  def [](key)
    get(key)
  end

  def set(key, value)
    environment[key] = String(value)
  end

  def get(key)
    get_type_cast(key)
  end

  def get_type_cast(key)
    get_as_envy_string(key).public_send(type_cast_method(key))
  end

  def get_as_envy_string(key)
    EnvySupport::String.new(get_before_type_cast_or_default(key))
  end

  def get_before_type_cast_or_default(key)
    get_before_type_cast(key) || get_default(key)
  end

  def get_before_type_cast(key)
    environment[key]
  end

  def get_default(key)
    String(@@config.dig(key, :default))
  end

  def configure(*args)
    self.class.configure(*args)
  end

  private
  def type_cast_method(key)
    value_type = @@config.dig(key, :type)
    TYPE_CAST_METHODS[value_type]
  end
end

module EnvySupport
  class String < SimpleDelegator
    def to_bool
      __getobj__ == "true"
    end
  end
end
