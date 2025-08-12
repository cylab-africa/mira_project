#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:$PATH

# ISO UTC timestamp for filename and logging
datetime_utc=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
timestamp=$(date -u +"%Y-%m-%d_%H-%M")

# Output CSV file
CSV_OUTPUT="/upz_probe/reports/mtr_result_${timestamp}.csv"

# Write CSV header
echo "Country,Site,DateTime,IP for the site,Path-Avg_latency" > "$CSV_OUTPUT"

# Check if IP_LIST is set
if [ -z "$IP_LIST" ]; then
    echo "IP_LIST not set. Please export IP_LIST='name,ip;name,ip'" >&2
    exit 1
fi

# Read list of IPs
IFS=';' read -ra IP_ARRAY <<< "$IP_LIST"

for entry in "${IP_ARRAY[@]}"; do
    IFS=',' read -ra ADDR <<< "$entry"
    site="${ADDR[0]}"
    ip="${ADDR[1]}"

    # Get country using geoiplookup
    ip_country=$(geoiplookup "$ip" | awk -F: '{gsub(/^ /, "", $2); print $2}' | cut -d',' -f1)

    echo "Running mtr for $site ($ip) — country: $ip_country — datetime: $datetime_utc"

    # Run mtr in JSON mode
    mtr_json=$(mtr --json -c 5 "$ip" 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$mtr_json" ]; then
        echo "mtr failed for $site ($ip), skipping" >&2
        continue
    fi

    # Escape double quotes for safe CSV embedding
    escaped_json=$(echo "$mtr_json" | sed 's/"/""/g')

    # Write CSV row
    printf "%s,%s,%s,%s,\"%s\"\n" \
      "$ip_country" "$site" "$datetime_utc" "$ip" "$escaped_json" >> "$CSV_OUTPUT"

done

echo "MTR collection complete → saved to $CSV_OUTPUT"
