from scapy.all import *
import sys

def syn_traceroute(target):
    print("Tracing route to", target)
    max_hops = 30
    port = 80  # Common port, you can change it

    for ttl in range(1, max_hops+1):
        # Creating the IP layer
        ip_layer = IP(dst=target, ttl=ttl)
        # Creating the TCP layer with SYN flag
        tcp_layer = TCP(dport=port, flags='S')
        # Sending the packet, receiving the reply
        packet = ip_layer/tcp_layer
        reply = sr1(packet, verbose=0, timeout=1)
        
        if reply is None:
            print(f"{ttl}\t*\tNo reply")
        elif reply.haslayer(TCP):
            print(f"{ttl}\t{reply.src}\t{reply[TCP].flags}")
            if reply[TCP].flags == 'SA':  # SYN-ACK flags
                print("Destination reached at hop", ttl)
                break
        elif reply.haslayer(ICMP):
            print(f"{ttl}\t{reply.src}\tICMP type {reply[ICMP].type}")
            if reply[ICMP].type == 3:
                print("Destination Unreachable")
                break
        else:
            print(f"{ttl}\tUnknown reply")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 syn_traceroute.py <destination>")
        sys.exit(1)
    target_ip = sys.argv[1]
    syn_traceroute(target_ip)
