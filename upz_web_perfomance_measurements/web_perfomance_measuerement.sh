#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:$PATH

# Extract the current hour and AM/PM
current_datetime=$(date +"%Y-%m-%d_%I%p") # Hour in 12-hour format with AM/PM

# Specify the output files
report_csv="/reports/lighthouse_report.csv"

# Check if the website file exists
website_file="/scripts/websites"

if [[ ! -f "$website_file" ]]; then
  echo "Error: The file 'website' does not exist in the current directory."
  exit 1
fi

# Loop through each line in the website file
while IFS= read -r site; do
  # Skip empty lines and lines starting with a comment (#)
  if [[ -z "$site" || "$site" =~ ^# ]]; then
    continue
  fi

  # Extract the site name
  site_name=$(echo "$site" | awk -F[/:] '{print $4}' | sed -E 's/^www\.//; s/\..*//')

  # Create the Lighthouse output file name
  LighthouseOutput="/reports/${site_name}_${current_datetime}.json"

  # Run Lighthouse with the --emulated-form-factor=mobile and --throttling-method=provided flags
  lighthouse "$site" --output=json --output-path=$LighthouseOutput --chrome-flags="--no-sandbox --headless" --quiet --emulated-form-factor=mobile --throttling-method=provided
  
  # Parse and save the results to the CSV
  jq -r --arg date "$current_datetime" '"\(.finalUrl),\(.audits["first-contentful-paint"].displayValue),\(.audits["largest-contentful-paint"].displayValue),\(.audits["speed-index"].displayValue),\(.audits["total-blocking-time"].displayValue),\(.audits["interactive"].displayValue),\($date)"' $LighthouseOutput >> $report_csv

done < "$website_file"

