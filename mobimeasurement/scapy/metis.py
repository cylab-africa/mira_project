from scapy.all import *
import sys

def icmp_traceroute(target):
    print("Tracing route to", target)
    max_hops = 30
    packets_per_hop = 3

    destination_reached = False  # Flag to track if destination is reached

    for ttl in range(1, max_hops+1):
        # Create the IP layer with increasing TTL
        ip_layer = IP(dst=target, ttl=ttl)
        # Create the ICMP layer with echo request type
        icmp_layer = ICMP()

        # Send packets and collect replies, printing only the first received reply
        received_reply = False
        for _ in range(packets_per_hop):
            packet = ip_layer / icmp_layer
            reply = sr1(packet, verbose=0, timeout=1)
            if reply is not None:
                if not received_reply:  # Print information only for the first reply
                    if reply.haslayer(ICMP):
                        print(f"{ttl}\t{reply.src}\tICMP type {reply[ICMP].type}")
                        if reply[ICMP].type == 0:  # Echo Reply
                            destination_reached = True
                            print("Destination reached at hop", ttl)
                            break  # Stop sending for this hop and entire loop
                        elif reply[ICMP].type == 3:
                            print("Destination Unreachable")
                            break
                    else:
                        print(f"{ttl}\t{reply.src}\tUnknown reply")
                received_reply = True  # Mark a reply received

        # Check if no reply was received for the entire hop
        if not received_reply:
            print(f"{ttl}\t*\tNo reply")

        # Exit the loop if destination is already reached
        if destination_reached:
            break

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 icmp_traceroute.py <destination>")
        sys.exit(1)
    target_ip = sys.argv[1]
    icmp_traceroute(target_ip)
