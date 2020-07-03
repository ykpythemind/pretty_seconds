require "test_helper"

class PrettySecondsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PrettySeconds::VERSION
  end

  def test_default_pretty_seconds
    assert_equal "1:50", pretty_seconds(110)
    assert_equal "0:09", pretty_seconds(9)
    assert_equal "10:02", pretty_seconds(602)
    assert_equal "11:14", pretty_seconds(674)
    assert_equal "1:1:15", pretty_seconds(3675)
    assert_equal "0:00", pretty_seconds(0)
    assert_equal "0:00", pretty_seconds(nil)
    assert_equal "1:11", pretty_seconds(71.54)
  end

  private

  def pretty_seconds(sec)
    ::PrettySeconds::Converter.new.convert(sec)
  end
end
