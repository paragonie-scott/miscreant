# encoding: binary
# frozen_string_literal: true

RSpec.describe Miscreant::Internals::AES::BlockCipher do
  let(:example_key) { ("\x01" * 16).b }

  describe "inspect" do
    it "does not contain instance variable values" do
      cipher = described_class.new(example_key)
      expect(cipher.inspect).to match(/\A#<#{described_class}:0[xX][0-9a-fA-F]+>\z/)
    end
  end

  context "AES" do
    describe "encrypt" do
      it "passes all AES-ECB test vectors" do
        described_class::Example.load_file.each do |ex|
          cipher = described_class.new(ex.key)
          expect(cipher.encrypt(ex.src)).to eq(ex.dst)
        end
      end
    end
  end
end
