require 'packetfu/protos/ipv6/header'
require 'packetfu/protos/ipv6/mixin'

module PacketFu

  # ICMPv6Header is a complete ICMPv6 struct, used in ICMPv6Packet.
  # ICMPv6 is typically used for network administration and connectivity
  # testing.
  #
  # For more on ICMP packets, see 
  # http://www.networksorcery.com/enp/protocol/icmpv6.htm
  # 
  # ==== Header Definition
  #
  #   Int8    :icmp_type                        # Type
  #   Int8    :icmp_code                        # Code
  #   Int16   :icmp_sum    Default: calculated  # Checksum
  #   String  :body
  class ICMPv6Header < Struct.new(:icmpv6_type, :icmpv6_code, :icmpv6_sum,
                                    :icmpv6_reserved, :icmpv6_tgt, :body)
    include StructFu

    PROTOCOL_NUMBER = 58

    def initialize(args={})
      super(
        Int8.new(args[:icmpv6_type]),
        Int8.new(args[:icmpv6_code]),
        Int16.new(args[:icmpv6_sum]),
        Int32.new(args[:icmpv6_reserved]),
        AddrIpv6.new.read(args[:icmpv6_tgt] || ("\x00" * 16)),
        StructFu::String.new.read(args[:body])
      )
    end

    # Returns the object in string form.
    def to_s
      self.to_a.map {|x| x.to_s}.join
    end
    
    # Reads a string to populate the object.
    def read(str)
      force_binary(str)
      return self if str.nil?
      self[:icmpv6_type].read(str[0,1])
      self[:icmpv6_code].read(str[1,1])
      self[:icmpv6_sum].read(str[2,2])
      self[:body].read(str[4,str.size])
      self
    end

    # Setter for the type.
    def icmpv6_type=(i); typecast i; end
    # Getter for the type.
    def icmpv6_type; self[:icmpv6_type].to_i; end
    # Setter for the code.
    def icmpv6_code=(i); typecast i; end
    # Getter for the code.
    def icmpv6_code; self[:icmpv6_code].to_i; end
    # Setter for the checksum. Note, this is calculated automatically with 
    # icmpv6_calc_sum.
    def icmpv6_sum=(i); typecast i; end
    # Getter for the checksum.
    def icmpv6_sum; self[:icmpv6_sum].to_i; end
    # Setter for the reserved.
    def icmpv6_reserved=(i); typecast i; end
    # Getter for the reserved.
    def icmpv6_reserved; self[:icmpv6_reserved].to_i; end
    # Setter for the target address.
    def icmpv6_tgt=(i); typecast i; end
    # Getter for the target address.
    def icmpv6_tgt; self[:icmpv6_tgt].to_i; end

    def icmpv6_sum_readable
      "0x%04x" % icmpv6_sum
    end

    # Get target address in a more readable form.
    def icmpv6_taddr
        self[:icmpv6_tgt].to_x
    end

    # Set the target address in a more readable form.
    def icmpv6_taddr=(str)
        self[:icmpv6_tgt].read_x(str)
    end

    alias :icmpv6_tgt_readable :icmpv6_taddr

  end
end
