require 'active_record'

module TUTLectureBot
  ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: "lectures.sqlite3",
  )

  class CanceledLecture < ActiveRecord::Base
  end

  class ExtraLecture < ActiveRecord::Base
  end
end
