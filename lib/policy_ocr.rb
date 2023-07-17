# frozen_string_literal: true

require_relative '../constants/constants'

module PolicyOcr
  class ScanOcr
    def extract_number(file_path)
      extracted_number = parse_text(file_path)
      write_parsed_numbers(extracted_number)
      extracted_number
    end

    def parse_text(file_path)
      digits = []
      extracted_number = []

      File.open(file_path, 'r') do |file|
        while !file.eof?
          lines = file.take(4)
          lines[0].each_char.with_index do |_, obj|
            next if obj % 3 != 0

            digit = lines[0][obj, DIGIT_SIZE] + lines[1][obj, DIGIT_SIZE] + lines[2][obj, DIGIT_SIZE]
            digits << (DIGIT_MAPPING[digit].nil? ? '?' : DIGIT_MAPPING[digit])
          end
          number = digits.join('').chop
          digits.clear
          extracted_number << number
        end
      end
      extracted_number
    end

    def write_parsed_numbers(extracted_number)
      File.open(PARSED_NUMBER_FILE, 'w') do |file|
        extracted_number.each do |number|
          file.write("#{number} \n")
        end
      end
    end

    def permute_numbers(file_path)
      valid_checksum_numbers = []

      extracted_numbers = extract_number(file_path)

      extracted_numbers.each do |number|
        next if valid_checksum?(number)

        dup_num = number.dup
        number.chars.each_with_index do |char ,index|
          possible_numbers = NUMBERS_MAPPING[char]
          possible_numbers&.each do |num|
            modified_num = dup_num.chars
            modified_num[index] = num
            modified_num = modified_num.join

            valid_checksum_numbers << modified_num if valid_checksum?(modified_num) && legal_number?(modified_num)
          end
        end
      end
      write_valid_checksum_numbers(valid_checksum_numbers)
    end

    def write_valid_checksum_numbers(valid_checksum_numbers)
      File.open(VALID_CHECKSUM_FILE, 'w') do |file|
        valid_checksum_numbers.each do |number|
          file.write("#{number} #{evaluate_number_tag(number)} \n")
        end
      end
    end

    def write_findings(file_path)
      extracted_number = extract_number(file_path)

      File.open(FINDINGS_FILE, 'w') do |file|
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
  # ScanOcr.new.extract_number(SAMPLE_FILE)  # user story 1
  # ScanOcr.new.write_findings(INVALID_NUMBERS_FILE) # user story 2 and 3
  # ScanOcr.new.permute_numbers(INVALID_NUMBERS_FILE)  # user story 4
end
