import numpy as np
from scapy.all import *
import sys

def icmp_traceroute(target):
    print("Tracing route to", target)
    max_hops = 30
    packets_per_hop = 3

    # Initialize empty lists to store results
    hop_data = []
    for _ in range(max_hops):
        hop_data.append({"ip": None, "loss": 0, "sent": 0, "times": []})

    for ttl in range(1, max_hops+1):
        # Create the IP layer with increasing TTL
        ip_layer = IP(dst=target, ttl=ttl)
        # Create the ICMP layer with echo request type
        icmp_layer = ICMP()
        # Sending the packet and receiving replies
        sent_count = 0
        replies = []
        for _ in range(packets_per_hop):
            packet = ip_layer / icmp_layer
            reply = sr1(packet, verbose=0, timeout=1)
            sent_count += 1
            if reply is not None:
                replies.append(reply.time)

        # Calculate statistics
        received_count = len(replies)
        loss_percent = (1 - received_count / packets_per_hop) * 100
        if received_count > 0:
            min_time = min(replies)
            max_time = max(replies)
            avg_time = sum(replies) / received_count
            std_dev = np.std(replies) if received_count > 1 else 0  # Use numpy for std_dev
        else:
            min_time = max_time = avg_time = std_dev = None

        # Update hop data
        if received_count > 0 and isinstance(replies[0], Packet):
            hop_data[ttl-1]["ip"] = replies[0].src
        else:
            hop_data[ttl-1]["ip"] = "*"

        # hop_data[ttl-1]["ip"] = replies[0].src if received_count > 0 else "*"  # Use first reply's source IP
        hop_data[ttl-1]["loss"] = loss_percent
        hop_data[ttl-1]["sent"] = packets_per_hop
        hop_data[ttl-1]["times"].extend(replies)

        # Print results
        print(f"{ttl}\t|-- {hop_data[ttl-1]['ip'] if hop_data[ttl-1]['ip'] else '*'} {loss_percent:.1f}%  {packets_per_hop}  {min_time:.2f}  {avg_time:.2f}  {max_time:.2f}  {std_dev:.2f}")


        # Check for destination reached or timeout
        if any(isinstance(reply, Packet) and reply.haslayer(ICMP) and reply[ICMP].type == 0 for reply in replies) if replies else False:
            # Code to execute if there's at least one successful ICMP echo reply
             print("Destination reached at hop", ttl)
        # else:
        #     # Code to execute if there are no replies or no successful reply

        # if any(reply.haslayer(ICMP) and reply[ICMP].type == 0 for reply in replies):
        #     print("Destination reached at hop", ttl)
        #     break

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 icmp_traceroute.py <destination>")
        sys.exit(1)
    target_ip = sys.argv[1]
    icmp_traceroute(target_ip)

