#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:$PATH

# UTC timestamp for filename and standard datetime
datetime_utc=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
timestamp=$(date -u +"%Y-%m-%d_%H-%M")

# File inputs and outputs
IPs_data="/upz_probe/scripts/IPs_data"
CSV_OUTPUT="/upz_probe/reports/mtr_result_${timestamp}.csv"

# CSV Header
echo "Country,Site,DateTime,IP for the site,Path-Avg_latency" > "$CSV_OUTPUT"

# Read each line of IPs_data (format: site,ip)
while IFS=, read -r site ip || [[ -n "$site" ]]; do
    # Get country via geoiplookup
    ip_country=$(geoiplookup "$ip" | awk -F: '{gsub(/^ /, "", $2); print $2}' | cut -d',' -f1)

    echo "Running mtr for $site ($ip) — $ip_country @ $datetime_utc"

    # Run mtr in JSON mode with 5 probes
    mtr_json=$(mtr --json -c 5 "$ip" 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$mtr_json" ]; then
        echo "mtr failed for $site ($ip), skipping..." >&2
        continue
    fi

    # Escape double quotes for safe CSV embedding
    escaped_json=$(echo "$mtr_json" | sed 's/"/""/g')

    # Write row to CSV
    printf "%s,%s,%s,%s,\"%s\"\n" \
        "$ip_country" "$site" "$datetime_utc" "$ip" "$escaped_json" >> "$CSV_OUTPUT"

done < "$IPs_data"

echo "All probes complete — CSV saved to $CSV_OUTPUT"
