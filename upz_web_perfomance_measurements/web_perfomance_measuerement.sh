#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:$PATH

# Extract the current hour and AM/PM
current_datetime=$(date +"%I%p") # Hour in 12-hour format with AM/PM

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


# Run Lighthouse audit 
: '
This Lighthouse command performs a performance audit on the https://google.com webpage. 
The results of the audit are tailored to provide insights on mobile device performance.

- `--output=csv`: Specifies the output format of the report to be CSV. This format is useful for data analysis and can be easily imported into spreadsheet applications.

- `--[no-]enable-error-reporting`: This flag allows you to enable or disable error reporting to Google. Prepending `no-` disables error reporting, providing a way to prevent sending error logs for privacy or security reasons.

- `--output-path=$LighthouseOutput`: This option specifies the file path where the report will be saved. The variable `$LighthouseOutput` should be defined in your environment or script, representing the path.

- `--emulated-form-factor=mobile`: Emulates a mobile device for the audit. This is important for understanding how the website performs on mobile platforms, which can significantly differ from desktop performance.

- `--throttling-method=provided`: Uses the throttling settings provided by the environment rather than Lighthouse’s internal settings. This is useful when the network conditions are externally controlled or known.

- `--only-categories=performance`: Limits the audit to performance metrics only. This focuses the report on critical aspects such as load time and interactivity, providing a clear view of the site’s performance.

'
#Lighthouse Report Json
# Extract the site name
  # Extract the primary domain name (e.g., "amazon" from "https://www.amazon.com/")
  site_name=$(echo "$site" | awk -F[/:] '{print $4}' | sed -E 's/^www\.//; s/\..*//')


  # Create the Lighthouse output file name
  LighthouseOutput="/reports/${site_name}_${current_datetime}.json"


  # Run Lighthouse with desktop emulation
  lighthouse "$site" --output=json --no-enable-error-reporting --output-path=$LighthouseOutput --emulated-form-factor=mobile --throttling-method=provided --only-categories=performance --chrome-flags="--no-sandbox --headless" --quiet 
  
  # Parse and save the results to the CSV
  jq -r --arg date "$current_datetime" '"\(.finalUrl),\(.audits["first-contentful-paint"].displayValue),\(.audits["largest-contentful-paint"].displayValue),\(.audits["speed-index"].displayValue),\(.audits["total-blocking-time"].displayValue),\(.audits["interactive"].displayValue),\($date)"' $LighthouseOutput >> $report_csv

  
done < "$website_file"

