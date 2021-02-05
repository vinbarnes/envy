require "forwardable"

class Envy
  TYPE_CAST_METHODS = {
    string: :to_s,
    integer: :to_i,
    boolean: :to_bool
  }

  extend Forwardable

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

  attr_reader :environment

  def_delegators :@environment, :has_key?

  # environment should default to ENV but can be overwritten for flexibility
  def initialize(environment)
    @environment = environment
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

  def get(key, default=nil)
    p environment
    puts ">>>"
    p type_cast_value = get_type_cast(key)
    if type_cast_value.present? || type_cast_value == false
      type_cast_value
    else
      default
    end
  end

  def get_type_cast(key)
    get_as_envy_string(key).presence&.public_send(type_cast_method(key))
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

    # Borrowed from ActiveSupport
    def blank?
      respond_to?(:empty?) ? !!empty? : !self
    end

    def present?
      !blank?
    end

    def presence
      self if present?
    end
  end
end
