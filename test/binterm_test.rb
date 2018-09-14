# frozen_string_literal: true
require_relative 'test_helper'
require_relative '../lib/binterm/version'

class BintermTest < Minitest::Test
	def test_that_it_has_a_version_number
		refute_nil ::BinTerm::VERSION
	end
end
