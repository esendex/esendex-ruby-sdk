require 'spec_helper'

module Esendex
  class DummyHashSerialisation
    include HashSerialisation

    attr_accessor :name, :time, :notes

  end

  describe HashSerialisation do
    let(:name) { random_string }
    let(:time) { random_time }
    let(:notes) { random_string }

    before(:each) do
      @attrs = { name: name, time: time, notes: notes }
    end

    describe "#initialize" do

      subject { DummyHashSerialisation.new @attrs }

      it "sets the name" do
        expect(subject.name).to eq name
      end
      it "sets the time" do
        expect(subject.time).to eq time
      end
      it "sets the notes" do
        expect(subject.notes).to eq notes
      end

      context "when invalid attribute passed" do
        before(:each) do
          @attrs[random_string] = random_string
        end
        it "should raise and argument error" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#to_hash" do
      subject { DummyHashSerialisation.new(@attrs).to_hash }

      it "should match the init hash" do
        expect(subject).to eq @attrs
      end
    end

  end
end
