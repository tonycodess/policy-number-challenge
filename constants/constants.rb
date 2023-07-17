NUMBERS_MAPPING = {
    '0' => [8],
    '1' => [7],
    '2' => [2],
    '3' => [9],
    '4' => [4],
    '5' => [6,9],
    '6' => [5,8],
    '7' => [1],
    '8' => [6,9],
    '9' => [8,5]
  }.freeze

  DIGIT_MAPPING = {
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
  }.freeze

  DIGIT_SIZE = 3.freeze
  
  PARSED_NUMBER_FILE = './spec/fixtures/parsed_numbers.txt'
  VALID_CHECKSUM_FILE = './spec/fixtures/valid_checksum.txt'
  FINDINGS_FILE = './spec/fixtures/findings.txt'
  SINGLE_NUMBER_FILE = './spec/fixtures/single_number.txt'
  MULTIPLE_NUMBERS_FILE = './spec/fixtures/multiple_numbers.txt'
  INVALID_NUMBERS_FILE = './spec/fixtures/invalid_numbers.txt'
  SAMPLE_FILE = './spec/fixtures/sample.txt'
