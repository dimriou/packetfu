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
    end

  end

end
