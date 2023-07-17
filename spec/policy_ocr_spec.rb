# frozen_string_literal: true

require_relative '../lib/policy_ocr'

RSpec.describe PolicyOcr::ScanOcr do
  let(:scan) { PolicyOcr::ScanOcr.new }

  it "loads Policy Module" do
    expect(PolicyOcr).to be_a(Module)
  end

  it "loads Scan Class" do
    expect(described_class).to be_a(Class)
  end

  it 'loads the sample.txt' do
    expect(fixture('sample').lines.count).to eq(44)
  end

  it 'checks the single number' do
    extracted_number = scan.extract_number('./spec/fixtures/single_number.txt').first.to_i
    expect(extracted_number).to eq(123456789)
  end

  it 'checks multiple numbers' do
    extracted_number = scan.extract_number('./spec/fixtures/multiple_numbers.txt')
    valid_numbers = extracted_number.all? { |number| number.chars.map(&:to_i).join('').eql?(number) }
    expect(valid_numbers).to eq(true)
  end

  it 'checks the number is legal' do
    expect(scan.legal_number?("987654321")).to eq(true)
  end

  it 'checks the number is illegal' do
    expect(scan.legal_number?("9876543?1")).to eq(false)
  end

  it 'checks the number with valid checksum' do
    expect(scan.valid_checksum?("345882865")).to eq(true)
  end

  it 'checks the number with invalid checksum' do
    expect(scan.valid_checksum?("245882860")).to eq(false)
  end

  it 'write findings' do
    scan.write_findings('./spec/fixtures/invalid_numbers.txt')
  end
end
