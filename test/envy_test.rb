require "minitest/autorun"
require_relative "../lib/envy"

class EnvyTest < Minitest::Test
  def setup
  end

  def test_getters
    clear_env_vars!

    @envy = Envy.new
    assert_equal "/bin/bash", ENV["SHELL"]

    assert_equal "/bin/bash", @envy.get_before_type_cast("SHELL")
    assert_equal "/bin/bash", @envy.get_before_type_cast_or_default("SHELL")
    # assert_equal({}, @envy._config_hash)
    # assert_equal({type: :string, default: nil}, @envy._config_hash["XIT"])
    # assert_equal({type: :string, default: nil}, @envy._config_hash["SHELL"])
    # assert_equal :to_s, @envy.send(:type_cast_method, "SHELL")

    assert_equal "/bin/bash", @envy.get("SHELL")
    assert_equal "/bin/bash", @envy["SHELL"]
  end

  def test_setters
    clear_env_vars!

    @envy = Envy.new
    assert_equal "xamot", @envy.set("XSTR", "xamot")
    assert_equal "xamot", @envy.get_before_type_cast("XSTR")

    assert_equal "true", @envy.set("XENABLED", true)
    assert_equal "false", @envy.set("XENABLED", false)

  end

  def test_configurers
    clear_env_vars!

    @envy = Envy.new
    @envy.configure("XSTR", :string, "xamot")
    assert_equal "xamot", @envy.get("XSTR")

    @envy.set("XNUM", "1")
    @envy.configure("XNUM", :integer)
    assert_equal "1", ENV["XNUM"]
    assert_equal 1, @envy.get("XNUM")

    @envy.set("XENABLED", "true")
    @envy.configure("XENABLED", :boolean)
    assert_equal "true", ENV["XENABLED"]
    assert_equal true, @envy.get("XENABLED")

    @envy.set("XENABLED", "false")
    assert_equal false, @envy.get("XENABLED")
    assert_equal false, @envy["XENABLED"]
  end

  def test_global_configuration
    clear_env_vars!

    Envy.config do |conf|
      conf.string "XSTR"
      conf.string "XSTR_DEFAULT", "tomax"
      conf.integer "XNUM"
      conf.integer "XNUM_DEFAULT", 42
      conf.boolean "XENABLED"
      conf.boolean "XENABLED_DEFAULT", true
    end

    @envy = Envy.new
    @envy.set("XSTR", "xamot")
    @envy.set("XNUM", "0")
    @envy.set("XENABLED", "false")

    assert_equal "xamot", @envy.get("XSTR")
    assert_equal "tomax", @envy.get("XSTR_DEFAULT")

    assert_equal 0, @envy.get("XNUM")
    assert_equal 42, @envy.get("XNUM_DEFAULT")

    refute @envy.get("XENABLED")
    assert @envy.get("XENABLED_DEFAULT")
  end

  def test_coercing_boolean
    clear_env_vars!

    Envy.config do |config|
      config.boolean "XENABLED"
      config.boolean "XENABLED_DEFAULT", true
    end

    @envy = Envy.new
    @envy.set("XENABLED", true)
    assert_equal true, @envy.get("XENABLED")
    assert_equal true, @envy.get("XENABLED_DEFAULT")
  end

  private
  def clear_env_vars!
    %w[XSTR XSTR_DEFAULT XNUM XNUM_DEFAULT XENABLED XENABLED_DEFAULT].each { |key|
      ENV[key] = nil
    }
  end

end
