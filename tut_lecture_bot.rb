#/usr/bin/env ruby
# coding: utf-8

require 'logger'
require_relative "lib/tut_lecture_bot"

module TUTLectureBot
  logger = Logger.new("log/tut_lecture_bot.log", "daily")
  logger.info("start")

  tweet_composer = TweetComposer.new(YAML.load_file("settings.yml"))

  loop do
    canceled_lectures, extra_lectures = nil, nil

    logger.info("accessing")
    begin
      agent = Agent.new
      canceled_lectures = agent.lectures(:canceled)
      extra_lectures = agent.lectures(:extra)
    rescue StandardError => e
      logger.error(e.inspect)
    else
      canceled_lectures.each do |canceled_lecture|
        tweet_composer.tweet(canceled_lecture, :canceled) do |loginfo|
          logger.info(loginfo)
          sleep(10)
        end
      end

      extra_lectures.each do |extra_lecture|
        tweet_composer.tweet(extra_lecture, :extra) do |loginfo|
          logger.info(loginfo)
          sleep(10)
        end
      end
    end

    logger.info("sleeping")
    sleep(20 * 60)
  end
end
