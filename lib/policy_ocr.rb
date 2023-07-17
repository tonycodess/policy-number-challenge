# frozen_string_literal: true

module PolicyOcr
  class ScanOcr
    def extract_number(file_path)
      extracted_number = parse_text(file_path)
      write_parsed_numbers(extracted_number)
      extracted_number
    end

    def parse_text(file_path)
      digit_mapping = {
        ' _ | ||_|' => '0',
        '     |  |' => '1',
        ' _  _||_ ' => '2',
        ' _  _| _|' => '3',
        '   |_|  |' => '4',
        ' _ |_  _|' => '5',
        ' _ |_ |_|' => '6',
        ' _   |  |' => '7',
        ' _ |_||_|' => '8',
        ' _ |_| _|' => '9'
      }

      digit_size = 3
      digits = []
      extracted_number = []

      File.open(file_path, 'r') do |file|
        while !file.eof?
          lines = file.take(4)
          lines[0].each_char.with_index do |_, obj|
            next if obj % 3 != 0

            digit = lines[0][obj, digit_size] + lines[1][obj, digit_size] + lines[2][obj, digit_size]
            digits << (digit_mapping[digit].nil? ? '?' : digit_mapping[digit])
          end
          number = digits.join('').chop
          digits.clear
          extracted_number << number
        end
      end
      extracted_number
    end

    def write_parsed_numbers(extracted_number)
      File.open('./spec/fixtures/parsed_numbers.txt', 'w') do |file|
        extracted_number.each do |number|
          file.write("#{number} \n")
        end
      end
    end

    def write_findings(file_path)
      extracted_number = extract_number(file_path)

      File.open('./spec/fixtures/findings.txt', 'w') do |file|
        extracted_number.each do |number|
          file.write("#{number} #{evaluate_number_tag(number)} \n")
        end
      end
    end

    def evaluate_number_tag(number)
      if !legal_number?(number)
        'ILL'
      elsif !valid_checksum?(number)
        'ERR'
      else
        ''
      end
    end

    def legal_number?(number)
      number.to_s.chars.all? { |digit| digit.to_i.to_s == digit }
    end

    def valid_checksum?(policy_number)
      weights = [9, 8, 7, 6, 5, 4, 3, 2, 1]
      digits = policy_number.to_s.chars.map(&:to_i)

      checksum = digits.each_with_index.sum { |digit, index| digit * weights[index] }
      (checksum % 11).zero?
    end
  end
  # ScanOcr.new.extract_number('./spec/fixtures/sample.txt')
end
  