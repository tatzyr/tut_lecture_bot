require "mechanize"

module TUTLectureBot
  class Agent
    URL = "https://kyomu.office.tut.ac.jp/portal/Public/Board/BoardList.aspx"
    CANCELED_XPATH = '//*[@id="ctl00_phContents_ucBoardLctList_grvCancel"]/tr'
    EXTRA_XPATH = '//*[@id="ctl00_phContents_ucBoardLctList_grvSupplement"]/tr'

    def initialize
      @agent = Mechanize.new { |a| a.user_agent_alias = "Mac Safari" }
      @page = @agent.get(URL)
    end

    def lectures(type)
      case type
      when :canceled
        table_body(type).map { |cell|
          CanceledLecture.find_or_initialize_by(
            day: cell[1],
            hour: cell[2],
            name: cell[3],
            teacher: cell[4],
            grade: cell[5],
            department: cell[6],
            extra_day: cell[9],
          )
        }
      when :extra
        table_body(type).map { |cell|
          ExtraLecture.find_or_initialize_by(
            day: cell[1],
            hour: cell[2],
            name: cell[3],
            teacher: cell[4],
            grade: cell[5],
            department: cell[6],
            room: cell[7],
          )
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

      @page.parser.xpath(xpath).map { |table| table.xpath("td").map { |cell| cell.text.strip } }[1..-1]
    end
  end
end
