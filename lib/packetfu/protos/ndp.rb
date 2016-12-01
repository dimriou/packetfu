# coding: binary
require 'packetfu/protos/eth/header'
require 'packetfu/protos/eth/mixin'

require 'packetfu/protos/ipv6/header'
require 'packetfu/protos/ipv6/mixin'

require 'packetfu/protos/ndp/header'
require 'packetfu/protos/ndp/mixin'

module PacketFu

  # NDPPacket is used to construct NDP Packets. They contain an EthHeader,
  # an IPv6Header, and a ICMPv6Header.
  #
  # == Example
  #
  #  ndp_pkt.new
  #  ndp_pkt.ndp_type = 136
  #  ndp_pkt.ndp_code = 0
  #
  #  ndp_pkt.ipv6_saddr="2000::1234"
  #  ndp_pkt.ipv6_daddr="2000::5678"
  #
  #  ndp_pkt.recalc
  #  ndp_pkt.to_f('/tmp/ndp.pcap')
  #
  # == Parameters
  #
  #  :eth
  #     A pre-generated EthHeader object.
  #  :ipv6
  #     A pre-generated IPv6Header object.
  #  :ndp
  #     A pre-generated NDPHeader object.
  class NDPPacket < Packet
    include ::PacketFu::EthHeaderMixin
    include ::PacketFu::IPv6HeaderMixin
    include ::PacketFu::NDPHeaderMixin

    attr_accessor :eth_header, :ipv6_header, :ndp_header

    def self.can_parse?(str)
      return false unless str.size >= 58
      return false unless EthPacket.can_parse? str
      return false unless IPv6Packet.can_parse? str
      return false unless str[20,1] == [PacketFu::NDPHeader::PROTOCOL_NUMBER].pack('C')
      return true
    end

    def read(str=nil, args={})
      raise "Cannot parse `#{str}'" unless self.class.can_parse?(str)
      @eth_header.read(str)
      super(args)
      self
    end

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
    end

    # Recalculates the calculatable fields for ICMPv6.
    def ndp_recalc(arg=:all)
    end

  end

end
