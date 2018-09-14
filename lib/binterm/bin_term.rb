# frozen_string_literal: true
require 'rubyserial'

module BinTerm
	class BinTerm
		def initialize(device_path:, baud:)
			@device_path = device_path
			@baud = baud

		end


		def run
			@connection = Serial.new @device_path, @baud

			launch_read_thread
			$stdout.sync = true

			while (line = $stdin.gets)
				begin
					line.strip!
					bytes = line.split(' ').map do |b|
						value = 0
						b.unpack('C*').reverse.each_with_index do |character_code, index|
							decimal = ascii_hex_value character_code
							value += decimal * 16 ** index
						end
						value
					end

					@connection.write bytes.pack('C*')
				rescue => e
					puts "ERR: #{e}"
				end
			end
		end


		private


		def ascii_hex_value(value)
			case value
				# 0 - 9
				when 48..57
					value - 48
				# a - f
				when 97..102
					value - 87
				# A - F
				when 65..70
					value - 55
				else
					raise "Invalid hex character: #{value.chr.inspect}"
			end
		end


		def launch_read_thread
			Thread.new do
				loop do
					begin
						data = @connection.read 1024
						hex_dump data if data
						sleep 0.01
					end
				end
			end
		end


		def hex_dump(byte_string)
			bytes_per_line = 32
			offset = 0

			byte_string.unpack('C*').each_slice(bytes_per_line) do |bytes|
				hex_groups = []
				bytes.each_slice(8) do |group|
					hex_groups.push format('%0x ' * group.length, *group).strip
				end
				display = bytes.map { |b| b >= 32 && b <= 126 ? b.chr : '.' }.join

				line = format '%08d | %s | %s', offset, hex_groups.join(' '), display
				puts line

				offset += bytes.length
			end
		end
	end
end
