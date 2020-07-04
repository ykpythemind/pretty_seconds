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
    assert_equal "1:12", pretty_seconds(71.54)
  end

  def test_keep_zero
    assert_equal "24", pretty_seconds(24, keep_zero: nil)
    assert_equal "0:24", pretty_seconds(24, keep_zero: :minute)
    assert_equal "0:0:24", pretty_seconds(24, keep_zero: :hour)

    assert_equal "1:25", pretty_seconds(85, keep_zero: nil)
    assert_equal "1:25", pretty_seconds(85, keep_zero: :minute)
    assert_equal "0:1:25", pretty_seconds(85, keep_zero: :hour)
  end

  def test_truncate
    assert_equal "1:11.54", pretty_seconds(71.54, truncate: :disabled)
    assert_equal "1:11.54", pretty_seconds(71.5425, truncate: :disabled)
    assert_equal "1:11.55", pretty_seconds(71.547, truncate: :disabled)
    assert_equal "1:11", pretty_seconds(71.54, truncate: :floor)
    assert_equal "1:12", pretty_seconds(71.54, truncate: :round)
  end

  def test_shorthand
    assert_equal "1:1:15", PrettySeconds.convert(3675)
    assert_equal "0:0:24", PrettySeconds.convert(24, keep_zero: :hour)
  end

  private

  def pretty_seconds(sec, opts = {})
    ::PrettySeconds::Converter.new(**opts).convert(sec)
  end
end
