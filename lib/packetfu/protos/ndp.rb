# coding: binary
require 'packetfu/protos/eth/header'
require 'packetfu/protos/eth/mixin'

require 'packetfu/protos/ipv6/header'
require 'packetfu/protos/ipv6/mixin'

require 'packetfu/protos/ndp/header'
require 'packetfu/protos/ndp/mixin'

module PacketFu
  class NDPPacket < Packet
    include ::PacketFu::EthHeaderMixin
    include ::PacketFu::IPv6HeaderMixin
    include ::PacketFu::NDPHeaderMixin

    attr_accessor :eth_header, :ipv6_header, :ndp_header

    def initialize(args={})
      @eth_header = EthHeader.new(args).read(args[:eth])
      @ipv6_header = IPv6Header.new(args).read(args[:ipv6])
      @ipv6_header.ipv6_next = PacketFu::NDPHeader::PROTOCOL_NUMBER
      @ndp_header = NDPHeader.new(args).read(args[:ndp])

      @ipv6_header.body = @ndp_header
      @eth_header.body = @ipv6_header

      @headers = [@eth_header, @ipv6_header, @ndp_header]
      super
      ndp_calc_sum
    end

    # Calculates the checksum for the object.
    def ndp_calc_sum
      checksum = 0

      # Compute sum on pseudo-header
      [ipv6_src, ipv6_dst].each do |iaddr|
        8.times { |i| checksum += (iaddr >> (i*16)) & 0xffff }
      end
      checksum += PacketFu::NDPHeader::PROTOCOL_NUMBER
      checksum += ipv6_len
      # Continue with entire ICMPv6 message.
      checksum += (ndp_type.to_i << 8) + ndp_code.to_i
      checksum += ndp_reserved.to_i >> 16
      checksum += ndp_reserved.to_i & 0xffff
      8.times { |i| checksum += (ndp_tgt.to_i >> (i*16)) & 0xffff }
      checksum += (ndp_opt_type.to_i << 8) + ndp_opt_len.to_i

      mac2int = ndp_lla.to_s.unpack('H*').first.to_i(16)
      3.times { |i| checksum += (mac2int >> (i*16)) & 0xffff }

      checksum = checksum % 0xffff
      checksum = 0xffff - checksum
      checksum == 0 ? 0xffff : checksum

    end

    # Recalculates the calculatable fields for NDP.
    def ndp_recalc(arg=:all)
      arg = arg.intern if arg.respond_to? :intern
      case arg
      when :ndp_sum
        self.ndp_sum = ndp_calc_sum
      when :all
        self.ndp_sum = ndp_calc_sum
      else
        raise ArgumentError, "No such field `#{arg}'"
      end
    end

  end

end
