module PacketFu
  # This Mixin simplifies access to the ICMPv6Headers. Mix this in with your 
  # packet interface, and it will add methods that essentially delegate to
  # the 'icmpv6_header' method (assuming that it is a ICMPv6Header object)
  module ICMPv6HeaderMixin
    def icmpv6_type=(v); self.icmpv6_header.icmpv6_type= v; end
    def icmpv6_type; self.icmpv6_header.icmpv6_type; end
    def icmpv6_code=(v); self.icmpv6_header.icmpv6_code= v; end
    def icmpv6_code; self.icmpv6_header.icmpv6_code; end
    def icmpv6_sum=(v); self.icmpv6_header.icmpv6_sum= v; end
    def icmpv6_sum; self.icmpv6_header.icmpv6_sum; end
    def icmpv6_reserved=(v); self.icmpv6_header.icmpv6_reserved= v; end
    def icmpv6_reserved; self.icmpv6_header.icmpv6_reserved; end
    def icmpv6_tgt=(v); self.icmpv6_header.icmpv6_tgt= v; end
    def icmpv6_tgt; self.icmpv6_header.icmpv6_tgt; end
    def icmpv6_taddr=(v); self.icmpv6_header.icmpv6_taddr= v; end
    def icmpv6_taddr; self.icmpv6_header.icmpv6_taddr; end
    def icmpv6_tgt_readable; self.icmpv6_header.icmpv6_tgt_readable; end
    def icmpv6_opt_type=(v); self.icmpv6_header.icmpv6_opt_type= v; end
    def icmpv6_opt_type; self.icmpv6_header.icmpv6_opt_type; end
    def icmpv6_opt_len=(v); self.icmpv6_header.icmpv6_opt_len=v; end
    def icmpv6_opt_len;self.icmpv6_header.icmpv6_opt_len; end
    def icmpv6_lla=(v); self.icmpv6_header.icmpv6_lla=v; end
    def icmpv6_lla;self.icmpv6_header.icmpv6_lla; end
    def icmpv6_lla_readable; self.icmpv6_header.icmpv6_lla_readable; end 
    def icmpv6_sum_readable; self.icmpv6_header.icmpv6_sum_readable; end
  end
end
