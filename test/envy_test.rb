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

  def teardown
    clear_global_config!
  end

  def test_getter_with_existing_key_value
    assert_equal "/bin/bash", @envy.get("SHELL")
    assert_equal "42", @envy.get("XNUM")
  end

  def test_getter_with_existing_key_value_and_default
    assert_equal "/bin/bash", @envy.get("SHELL", "/bin/zsh")
    assert_equal "42", @envy.get("XNUM", "99")
  end

  def test_getter_with_nonexistant_key
    assert_nil @envy.get("XYZEBRA")
  end

  def test_getter_with_nonexistant_key_and_default
    assert_equal "striped horse", @envy.get("XYZEBRA", "striped horse")
  end

  def test_setter_with_existing_key_value
    assert_equal "tomax", @envy.set("XSTR", "tomax")
    assert_equal "false", @envy.set("XON", "false")
  end

  def test_setter_with_nonexistent_key_value
    assert_equal "smurf", @envy.set("XSTR_XTRA", "smurf")
    assert_equal "true", @envy.set("XON_XTRA", "true")
  end

  def test_getter_typecast_with_nonexistant_key
    @envy.configure("SHELL_TYPECAST", :string)
    assert_nil @envy.get("SHELL_TYPECAST")
  end

  def test_getter_typecast_with_existing_key_value
    @envy.configure("XSTR", :string)
    assert_equal "xamot", @envy.get("XSTR")

    @envy.configure("XNUM", :integer)
    assert_equal 42, @envy.get("XNUM")

    @envy.configure("XON", :boolean)
    assert_equal true, @envy.get("XON")
  end

  def test_getter_typecast_and_default_with_nonexistant_key
    @envy.configure("XSTR_NONEXISTANT", :string, "tomax")
    assert_equal "tomax", @envy.get("XSTR_NONEXISTANT")

    # @envy.configure("XNUM", :integer)
    # assert_equal 42, @envy.get("XNUM")

    # @envy.configure("XON", :boolean)
    # assert_equal true, @envy.get("XON")
  end

  # def test_configurers
  #   @envy.configure("XSTR", :string, "xamot")
  #   assert_equal "xamot", @envy.get("XSTR")

  #   @envy.set("XNUM", "1")
  #   @envy.configure("XNUM", :integer)
  #   assert_equal 1, @envy.get("XNUM")

  #   @envy.set("XON", "true")
  #   @envy.configure("XON", :boolean)
  #   assert_equal true, @envy.get("XON")

  #   @envy.set("XON", "false")
  #   assert_equal false, @envy.get("XON")
  #   assert_equal false, @envy["XON"]
  # end

  # def test_global_configuration
  #   Envy.config do |conf|
  #     conf.string "XSTR"
  #     conf.string "XSTR_DEFAULT", "tomax"
  #     conf.integer "XNUM"
  #     conf.integer "XNUM_DEFAULT", 42
  #     conf.boolean "XON"
  #     conf.boolean "XON_DEFAULT", true
  #   end

  #   @envy.set("XSTR", "xamot")
  #   @envy.set("XNUM", "0")
  #   @envy.set("XON", "false")

  #   assert_equal "xamot", @envy.get("XSTR")
  #   assert_equal "tomax", @envy.get("XSTR_DEFAULT")

  #   assert_equal 0, @envy.get("XNUM")
  #   assert_equal 42, @envy.get("XNUM_DEFAULT")

  #   refute @envy.get("XON")
  #   assert @envy.get("XON_DEFAULT")
  # end

  # def test_coercing_boolean
  #   Envy.config do |config|
  #     config.boolean "XON"
  #     config.boolean "XON_DEFAULT", true
  #   end

  #   @envy.set("XON", true)
  #   assert_equal true, @envy.get("XON")
  #   assert_equal true, @envy.get("XON_DEFAULT")
  # end

  private
  def clear_global_config!
    Envy.class_variable_get(:@@config).clear
  end

end
