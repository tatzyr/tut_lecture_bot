#!/usr/bin/env ruby

require "logger"
require_relative "lib/tut_lecture_bot"

logger = Logger.new(STDOUT)

REQUIRED_ENV_KEYS = %w[
  B_CONSUMER_KEY
  B_CONSUMER_SECRET
  B_ACCESS_TOKEN
  B_ACCESS_TOKEN_SECRET
  M_CONSUMER_KEY
  M_CONSUMER_SECRET
  M_ACCESS_TOKEN
  M_ACCESS_TOKEN_SECRET
]

unless REQUIRED_ENV_KEYS.all? { |k| ENV[k] }
  logger.error("these environment variables are required: #{REQUIRED_ENV_KEYS.join(", ")}")
  exit 1
end

begin
  logger.info("start")

  option = TUTLectureBot::Option.new(
    ENV["B_CONSUMER_KEY"],
    ENV["B_CONSUMER_SECRET"],
    ENV["B_ACCESS_TOKEN"],
    ENV["B_ACCESS_TOKEN_SECRET"],
    ENV["M_CONSUMER_KEY"],
    ENV["M_CONSUMER_SECRET"],
    ENV["M_ACCESS_TOKEN"],
    ENV["M_ACCESS_TOKEN_SECRET"],
  )

  agent = TUTLectureBot::Agent.new
  canceled_lectures = agent.lectures(:canceled)
  extra_lectures = agent.lectures(:extra)

  tweet_composer = TUTLectureBot::TweetComposer.new(option)

  canceled_lectures.each do |canceled_lecture|
    tweet_composer.tweet(canceled_lecture) do |loginfo|
      logger.info(loginfo)
      sleep(10)
    end
  end

  extra_lectures.each do |extra_lecture|
    tweet_composer.tweet(extra_lecture) do |loginfo|
      logger.info(loginfo)
      sleep(10)
    end
  end
rescue => e
  logger.error(e)
ensure
  logger.info("end")
end
