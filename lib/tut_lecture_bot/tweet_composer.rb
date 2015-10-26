require 'active_support/core_ext/date'
require 'active_support/core_ext/time'
require 'active_support/core_ext/numeric/time'
require 'mustache'
require_relative 'normalize_string'


module TUTLectureBot
  class TweetComposer
    using NormalizeString

    def initialize(bachelor:, master:)
      @client_b = Twitter::REST::Client.new(bachelor)
      @client_m = Twitter::REST::Client.new(master)
    end

    def tweet(data, type)
      lecture =
        case type
        when :canceled
          CanceledLecture
        when :extra
          ExtraLecture
        end

      record = lecture.find_or_initialize_by(data)

      if record.new_record?
        update(data, type)
        yield [data[:name], type, false] if block_given?
        record.save!
      end

      tomorrow = Date.parse(record.day) == 12.hours.from_now.to_date
      today = Date.parse(record.day) == Date.today
      if !record.reminded && tomorrow && !today
        update(data, type, true)
        record.update(reminded: true)
        yield [data[:name], type, true] if block_given?
        record.save!
      end
    end

    private
    def update(data, type, remind = false)
      tweet = render(data, type, remind)
      grade = normalize(data)[:grade]

      @client_b.update(tweet) if grade.match(/B/)
      @client_m.update(tweet) if grade.match(/[MD]/)
    end

    def render(data, type, remind)
      template =
        case type
        when :canceled
          File.read("#{__dir__}/templates/canceled.mustache")
        when :extra
          File.read("#{__dir__}/templates/extra.mustache")
        end

      args = normalize(data)
      args[:remind] = remind

      Mustache.render(template, args)
    end


    def normalize(data)
      data.dup.tap {|d|
        d[:teacher] = d[:teacher].normalize_name
        d[:grade] = d[:grade].split_strip.join("/")
        d[:department] = d[:department].split_strip.map{|dep| dep.department_to_number }.join("/")
        d[:day] = d[:day].normalize_date
      }
    end
  end
end
