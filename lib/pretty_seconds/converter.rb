module PrettySeconds
  class Converter
    def initialize(opts = {})
      @truncate = opts.fetch(:truncate) { false } # WIP
      @padding  = opts.fetch(:padding) { :except_first }.to_sym # WIP
      validate_padding_config!(@padding)

      @keep_zero = opts.fetch(:keep_zero) { :minute }.to_sym # WIP
      @nil_is_zero = true
    end

    MINUTE_SCALE = 60
    HOUR_SCALE = 60 * 60

    def convert(number)
      targets = []

      return if number.nil? && !@nil_is_zero

      if number
        hour = (number / HOUR_SCALE).round
        rest = (number % HOUR_SCALE)
        min = (rest / MINUTE_SCALE).round
        second = rest % MINUTE_SCALE
      else
        hour = 0
        min = 0
        second = 0
      end

      if hour != 0 || (hour == 0 && keep_zero_style?(:hour))
        targets << hour
      end

      if min != 0 || (min == 0 && second == 0 && keep_zero_style?(:hour, :minute))
        targets << min
      elsif min == 0 && second != 0 && keep_zero_style?(:hour, :minute)
        targets << min
      else
        targets << 0 if keep_zero_style?(:hour, :minute)
      end

      targets << pad(second)

      targets.join(':')
    end

    private

    def keep_zero_style?(*styles)
      styles.any? { |style| style == @keep_zero }
    end

    def pad(num)
      format("%02d", num)
    end

    PADDING_CONFIGS = [:pad_all, :except_first, :no_pad]

    def validate_padding_config!(sym)
      unless PADDING_CONFIGS.include?(sym)
        raise ArgumentError, "Padding config invalid: available paddings are #{PADDING_CONFIGS}"
      end
    end
  end
end
