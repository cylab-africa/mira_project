from scapy.all import *
import sys

def icmp_traceroute(target):
    print("Tracing route to", target)
    max_hops = 30

    for ttl in range(1, max_hops+1):
        # Creating the IP layer with increasing TTL
        ip_layer = IP(dst=target, ttl=ttl)
        # Creating the ICMP layer with echo request type
        icmp_layer = ICMP()
        # Sending the packet and receiving the reply
        packet = ip_layer/icmp_layer
        reply = sr1(packet, verbose=0, timeout=1)
        
        if reply is None:
            print(f"{ttl}\t*\tNo reply")
        elif reply.haslayer(ICMP):
            print(f"{ttl}\t{reply.src}\tICMP type {reply[ICMP].type}")
            if reply[ICMP].type == 0:  # Echo Reply
                print("Destination reached at hop", ttl)
                break
            elif reply[ICMP].type == 3:
                print("Destination Unreachable")
                break
        else:
            print(f"{ttl}\tUnknown reply")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 icmp_traceroute.py <destination>")
        sys.exit(1)
    target_ip = sys.argv[1]
    icmp_traceroute(target_ip)
