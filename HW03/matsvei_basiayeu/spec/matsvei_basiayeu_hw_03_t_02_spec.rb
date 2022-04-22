# frozen_string_literal: true

require 'rspec'
require_relative 'spec_helper'
require './matsvei_basiayeu_hw_03_t_02'

RSpec.describe Homework3 do
  subject { described_class.new.task2(logs) }

  describe 'Logs are right' do
    context 'when given text in right' do
      let(:logs) do
        <<~ENTRY_LOGS
          10.6.246.103 - - [32/Apr/2018:20:30:39 +03200] "POST /test/2/messages HTTP/1.1" 200 48 0.0498
          10.6.246.101 - - [32/Apr/2018:20:31:39 +03200] "POST /test/2/messages HTTP/1.1" 200 48 0.0290
          2018-04-32 20:30:42: SSL ERROR, peer: 10.6.246.101, peer cert: , #<Puma::MiniSSL::SSL: System error: Undefined error: 0 - 0>
          10.6.246.101 - - [32/Apr/2018:20:30:42 +03200] "POST /test/2/run HTTP/1.1" 200 - 0.2277'
        ENTRY_LOGS
      end
      let(:expected_output) do
        ['DATE: 32/Apr/2018:20:30:39 +03200 FROM: 10.6.246.103 TO: /TEST/2/MESSAGES',
         'DATE: 32/Apr/2018:20:31:39 +03200 FROM: 10.6.246.101 TO: /TEST/2/MESSAGES',
         'DATE: 32/Apr/2018:20:30:42 +03200 FROM: 10.6.246.101 TO: /TEST/2/RUN']
      end

      it 'returns an array of processed strings' do
        expect(subject).to eq(expected_output)
      end
    end

    context 'when logs have more than one error' do
      let(:logs) do
        <<~ENTRY_LOGS
          10.6.246.103 - - [23/Apr/2018:20:30:39 +0300] "POST /test/2/messages HTTP/1.1" 200 48 0.0498
          2018-04-23 20:30:42: SSL ERROR, peer: 10.6.246.101, peer cert: , #<Puma::MiniSSL::SSL: System error: Undefined error: 0 - 0>
          10.6.246.101 - - [23/Apr/2018:20:30:42 +0300] "POST /test/2/run HTTP/1.1" 200 - 0.2277
          2018-04-23 20:30:42: SSL ERROR, peer: 10.6.246.101, peer cert: , #<Puma::MiniSSL::SSL: System error: Undefined error: 0 - 0>
          10.6.246.101 - - [23/Apr/2018:20:31:39 +0300] "POST /test/2/messages HTTP/1.1" 200 48 0.0290
          2020-04-23 SSL ERROR, peer: 10.6.246.101, peer cert: , #<Puma::MiniSSL::SSL: System error: Undefined error: 0 - 0>
        ENTRY_LOGS
      end
      let(:expected_output) do
        [
          'DATE: 23/Apr/2018:20:30:39 +0300 FROM: 10.6.246.103 TO: /TEST/2/MESSAGES',
          'DATE: 23/Apr/2018:20:30:42 +0300 FROM: 10.6.246.101 TO: /TEST/2/RUN',
          'DATE: 23/Apr/2018:20:31:39 +0300 FROM: 10.6.246.101 TO: /TEST/2/MESSAGES'
        ]
      end

      it 'returns an array of processed strings' do
        expect(subject).to eq(expected_output)
      end
    end

    context 'when logs don`t have errors' do
      let(:logs) do
        <<~ENTRY_LOGS
          10.6.246.103 - - [23/Apr/2018:20:30:39 +0300] "POST /test/2/messages HTTP/1.1" 200 48 0.0498
          10.6.246.101 - - [23/Apr/2018:20:30:42 +0300] "POST /test/2/run HTTP/1.1" 200 - 0.2277
          10.6.246.101 - - [23/Apr/2018:20:31:39 +0300] "POST /test/2/messages HTTP/1.1" 200 48 0.0290
        ENTRY_LOGS
      end
      let(:expected_output) do
        [
          'DATE: 23/Apr/2018:20:30:39 +0300 FROM: 10.6.246.103 TO: /TEST/2/MESSAGES',
          'DATE: 23/Apr/2018:20:30:42 +0300 FROM: 10.6.246.101 TO: /TEST/2/RUN',
          'DATE: 23/Apr/2018:20:31:39 +0300 FROM: 10.6.246.101 TO: /TEST/2/MESSAGES'
        ]
      end

      it 'returns an array of formatted strings' do
        expect(subject).to eq(expected_output)
      end
    end
  end

  describe 'Log that has wrong output' do
    context 'when text are not given' do
      let(:logs) { '' }

      it 'returns an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'when text given in wrong format' do
      let(:logs) do
        <<~ENTRY_LOGS
          10.6.246.103 - - "POST /test/2/messages HTTP/1.1" 200 48 0.0498
          10.6.246.101 - -"POST /test/2/run HTTP/1.1" 200 - 0.2277
          2018-04-23 20:30:42: SSL ERROR, peer: 10.6.246.101, peer cert: , #<Puma::MiniSSL::SSL: System error: Undefined error: 0 - 0>
          10.6.246.101 - -"POST /test/2/messages HTTP/1.1" 200 48 0.0290
        ENTRY_LOGS
      end

      it 'returns an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'when logs are nil' do
      let(:logs) { nil }

      it 'returns an empty array' do
        expect(subject).to eq([])
      end
    end
  end
end
