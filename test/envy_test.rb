require "minitest/autorun"
require_relative "../lib/envy"

class EnvyTest < Minitest::Test
  def setup
    @envy = Envy.new({
      "SHELL" => "/bin/bash",
      "XSTR"  => "xamot",
      "XNUM"  => "42",
      "XON"   => "true"
    })
  end

  def test_getters
    # assert_equal "/bin/bash", @envy.get_before_type_cast("SHELL")
    # assert_equal "/bin/bash", @envy.get_before_type_cast_or_default("SHELL")

    puts ">>> before"
    assert_equal "/bin/bash", @envy.get("SHELL")
    # assert_equal "/bin/bash", @envy["SHELL"]
    puts ">>> after"

    # assert_nil @envy.get("XYZEBRA")
  end

  def test_setters
    assert_equal "xamot", @envy.set("XSTR", "xamot")
    assert_equal "xamot", @envy.get_before_type_cast("XSTR")

    assert_equal "true", @envy.set("XON", true)
    assert_equal "false", @envy.set("XON", false)
  end

  # def test_getters_with_fallback
  #   refute @envy.has_key? "QUIET_KNIGHT"
  #   assert_equal "bingo", @envy.get("QUIET_NIGHT", "bingo")
  # end

  def test_configurers
    @envy.configure("XSTR", :string, "xamot")
    assert_equal "xamot", @envy.get("XSTR")

    @envy.set("XNUM", "1")
    @envy.configure("XNUM", :integer)
    assert_equal 1, @envy.get("XNUM")

    @envy.set("XON", "true")
    @envy.configure("XON", :boolean)
    assert_equal true, @envy.get("XON")

    @envy.set("XON", "false")
    assert_equal false, @envy.get("XON")
    assert_equal false, @envy["XON"]
  end

  def test_global_configuration
    Envy.config do |conf|
      conf.string "XSTR"
      conf.string "XSTR_DEFAULT", "tomax"
      conf.integer "XNUM"
      conf.integer "XNUM_DEFAULT", 42
      conf.boolean "XON"
      conf.boolean "XON_DEFAULT", true
    end

    @envy.set("XSTR", "xamot")
    @envy.set("XNUM", "0")
    @envy.set("XON", "false")

    assert_equal "xamot", @envy.get("XSTR")
    assert_equal "tomax", @envy.get("XSTR_DEFAULT")

    assert_equal 0, @envy.get("XNUM")
    assert_equal 42, @envy.get("XNUM_DEFAULT")

    refute @envy.get("XON")
    assert @envy.get("XON_DEFAULT")
  end

  def test_coercing_boolean
    Envy.config do |config|
      config.boolean "XON"
      config.boolean "XON_DEFAULT", true
    end

    @envy.set("XON", true)
    assert_equal true, @envy.get("XON")
    assert_equal true, @envy.get("XON_DEFAULT")
  end

  private
  def clear_env_vars!
  end

end
