require "pretty_seconds/version"

module PrettySeconds
  def convert(number, opts = {})
    Converter.new(opts).convert(number)
  end

  extend self
end

require "pretty_seconds/converter"
