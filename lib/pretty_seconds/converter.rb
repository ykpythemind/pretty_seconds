module PrettySeconds
  class Converter
    def initialize(opts = {})
      @truncate_config    = (opts.fetch(:truncate) { :round } || :disabled).to_sym
      @padding_config     = opts.fetch(:padding) { true } # WIP
      @keep_zero_config   = (opts.fetch(:keep_zero) { :minute } || :disabled).to_sym
      @nil_is_zero_config = true # WIP

      validate_config!
    end

    def convert(number)
      targets = []

      return if number.nil? && !nil_is_zero_config

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

      if hour != 0 || (hour == 0 && keep_zero?(:hour))
        targets << hour
      end

      if min != 0 || (min == 0 && second == 0 && keep_zero?(:hour, :minute))
        targets << min
      elsif min == 0 && second != 0 && keep_zero?(:hour, :minute)
        targets << min
      else
        targets << 0 if keep_zero?(:hour, :minute)
      end

      if truncate_config == :round
        second = second.round
      elsif truncate_config == :floor
        second = second.floor
      else
        second = second.round(2) # disable
      end

      targets << pad(second)

      targets.join(':')
    end

    attr_reader :truncate_config,
                :padding_config,
                :keep_zero_config,
                :nil_is_zero_config

    MINUTE_SCALE = 60
    HOUR_SCALE = 60 * 60

    private

    def keep_zero?(*styles)
      styles.any? { |style| style == keep_zero_config }
    end

    def pad(num)
      return num if num >= 10

      "0#{num}"
    end

    KEEP_ZERO_CONFIGS = [:hour, :minute, :disabled]
    TRUNCATE_CONFIGS = [:round, :floor, :disabled]

    def validate_config!
      unless KEEP_ZERO_CONFIGS.include?(keep_zero_config)
        raise ArgumentError, "Keep zero config invalid: available configs are #{KEEP_ZERO_CONFIGS}"
      end

      unless TRUNCATE_CONFIGS.include?(truncate_config)
        raise ArgumentError, "Truncate config invalid: available configs are #{TRUNCATE_CONFIGS}"
      end
    end
  end
end
