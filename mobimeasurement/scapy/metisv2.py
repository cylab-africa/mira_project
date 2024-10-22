import numpy as np
from scapy.all import *
import sys
from datetime import datetime, timedelta

def icmp_traceroute(target):
    print("Traceroute Results to:",target)  # Print results heading
    print("Start:", datetime.utcnow().isoformat())  # Print start time in UTC
    max_hops = 30
    packets_per_hop = 3

    # Header with spacing and units (milliseconds)
    print("{:>2}|{:>24}|{:>4}|{:>7}|{:>7}|{:>7}|{:>7}".format(
        "Hop", "Loss%", "Snt", "Last", "Avg", "Best", "Wrst"))

    for ttl in range(1, max_hops+1):
        # Create the IP layer with increasing TTL
        ip_layer = IP(dst=target, ttl=ttl)
        # Create the ICMP layer with echo request type
        icmp_layer = ICMP()

        # Send packets and collect replies, calculating and printing results
        sent_times = []  # List to store send times of all packets for a hop
        received_replies = []  # List to store (reply, send_time) tuples
        for _ in range(packets_per_hop):
            send_time = datetime.utcnow()  # Record UTC send time for each packet
            sent_times.append(send_time)
            packet = ip_layer / icmp_layer
            reply = sr1(packet, verbose=0, timeout=1)

            if reply is not None:
                # Check for ICMP type 0 (Echo Reply)
                if reply.type == 0:  # Destination reached
                    received_replies.append((reply, send_time))
                    break  # Stop sending packets if destination is reached
                else:
                    received_replies.append((reply, send_time))  # Store other ICMP responses

        # Calculate loss percentage and analyze replies (if any)
        loss_percent = (1 - len(received_replies) / packets_per_hop) * 100
        if received_replies:
            reply_times = [reply.time for reply, _ in received_replies]

            # Last packet time (round-trip time)
            last_packet_time = reply_times[-1]  if received_replies else None

            # Average time (round-trip time)
            avg_time = sum(reply_times) / len(reply_times)

            # Best time (minimum round-trip time)
            best_time = min(reply_times)

            # Worst time (maximum round-trip time)
            worst_time = max(reply_times)

            # Standard deviation (round-trip time)
            std_dev = np.std(reply_times) if len(reply_times) > 1 else 0

            # Print results for the hop in minutes and milliseconds (2 decimal places)
            print(f"{ttl}.|-- {reply.src if received_replies else '*'}\t{loss_percent:.1f}%  {packets_per_hop}  "
                  f"{last_packet_time:.2f}  "
                  f"{avg_time:.2f}  "
                  f"{best_time:.2f}  "
                  f"{worst_time:.2f}  "
                  f"{std_dev:.2f}")
        else:
            print(f"{ttl}\t*\tNo reply")

        # Exit the loop if a reply with ICMP type 0 is received
        if any(reply.type == 0 for reply, _ in received_replies):
            break

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 icmp_traceroute.py <destination>")
        sys.exit(1)
    target_ip = sys.argv[1]
    icmp_traceroute(target_ip)
