require "active_support/core_ext/date"
require "active_support/core_ext/time"
require "active_support/core_ext/numeric/time"
require "twitter"

module TUTLectureBot
  class TweetComposer
    def initialize(option)
      @client_b = Twitter::REST::Client.new { |config|
        config.consumer_key = option.b_consumer_key
        config.consumer_secret = option.b_consumer_secret
        config.access_token = option.b_access_token
        config.access_token_secret = option.b_access_token_secret
      }
      @client_m = Twitter::REST::Client.new { |config|
        config.consumer_key = option.m_consumer_key
        config.consumer_secret = option.m_consumer_secret
        config.access_token = option.m_access_token
        config.access_token_secret = option.m_access_token_secret
      }
    end

    def tweet(record)
      if record.new_record?
        update(record)
        yield [record, false] if block_given?
        record.save!
      end

      tomorrow = Date.parse(record.day) == 12.hours.from_now.to_date
      today = Date.parse(record.day) == Date.today
      if !record.reminded && tomorrow && !today
        update(record, true)
        record.update(reminded: true)
        yield [record, true] if block_given?
        record.save!
      end
    end

    private

    def update(record, remind = false)
      tweet = record.render(remind)
      @client_b.update(tweet) if /B/.match?(record.normalized_grade)
      @client_m.update(tweet) if /[MD]/.match?(record.normalized_grade)
    end
  end
end
