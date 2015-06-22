module TUTLectureBot
  module NormalizeString
    DEPARTMENT_TABLE = {
      "機械" => "1系", # Mechanical Engineering
      "電気・電子情" => "2系", # Electrical and Electronic Information Engineering
      "情報・知能" => "3系", # Computer Science and Engineering
      "環境・生命" => "4系", # Environmental and Life Sciences
      "建築・都市" => "5系", # Architecture and Civil Engineering
      "共通" => "共通", # All Departments
      "電気電子情報" => "2系", # F---
    }

    refine String do
      def normalize_date
        gsub(/\/0/, "/").sub(/\A\d{4}\//, "")
      end

      def normalize_name
        gsub(/[\s　]+/, " ")
      end

      def split_strip
        split(",").map(&:strip)
      end

      def department_to_number
        DEPARTMENT_TABLE[self] || "エラー"
      end
    end
  end
end
