require "active_record"
require "erb"
require_relative "normalize_string"

module TUTLectureBot
  ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: "lectures.sqlite3",
  )

  class CanceledLecture < ActiveRecord::Base
    include NormalizeString

    def render(remind)
      @@template ||= File.read("#{__dir__}/templates/canceled.erb")
      @@erb ||= ERB.new(@@template)
      @@erb.result(binding)
    end
  end

  class ExtraLecture < ActiveRecord::Base
    include NormalizeString

    def render(remind)
      @@template ||= File.read("#{__dir__}/templates/extra.erb")
      @@erb ||= ERB.new(@@template)
      @@erb.result(binding)
    end
  end
end
