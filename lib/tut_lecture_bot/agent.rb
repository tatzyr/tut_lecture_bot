require 'mechanize'

module TUTLectureBot
  class Agent
    URL = "https://www.ead.tut.ac.jp/board/main.aspx"
    CANCELED_XPATH = '//*[@id="grvCancel"]/tr'
    EXTRA_XPATH = '//*[@id="grvSupplement"]/tr'

    def initialize
      @agent = Mechanize.new {|a| a.user_agent_alias = "Mac Safari" }
      @page = @agent.get(URL)
    end

    def lectures(type)
      case type
      when :canceled
        table_body(type).map {|cell|
          {
            day: cell[1],
            hour: cell[2],
            name: cell[3],
            teacher: cell[4],
            grade: cell[5],
            department: cell[6],
            extra_day: cell[8],
          }
        }
      when :extra
        table_body(type).map {|cell|
          {
            day: cell[1],
            hour: cell[2],
            name: cell[3],
            teacher: cell[4],
            grade: cell[5],
            department: cell[6],
            room: cell[7],
          }
        }
      end
    end

    private
    def table_body(type)
      xpath =
        case type
        when :canceled
          CANCELED_XPATH
        when :extra
          EXTRA_XPATH
        end

      @page.parser.xpath(xpath).map {|table| table.xpath("td").map {|cell| cell.text.strip } }[1..-1]
    end
  end
end
