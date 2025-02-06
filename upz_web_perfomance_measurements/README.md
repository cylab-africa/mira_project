# upz_web_performance_measurement

## Overview  
This container performs web performance measurements on specified websites using Lighthouse and monitors network usage using vnStat. The results are saved in CSV and log files for further analysis.

## Setup  
1. Clone the repository and navigate to the container directory:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```
2. Ensure the `websites` file is present in the container directory with the list of websites to be measured.

## Configuration  
### Modifying the List of Target Websites  
1. Open the `websites` file.
2. Add or remove websites, ensuring one website per line.
   **Example**:
   ```
   https://www.amazon.com
   https://www.youtube.com
   https://www.wikipedia.org
   ```

### Lighthouse Performance Measurement
The script `web_perfomance_measuerement.sh` runs periodically as a cron job and performs the following actions:
1. Reads the list of websites from the `websites` file.
2. Runs Lighthouse for each website with mobile emulation and provided throttling.
3. Saves the Lighthouse report in JSON format in the `/reports` directory.
4. Extracts key performance metrics and appends them to the `lighthouse_report.csv` file.

### Network Usage Monitoring
The script `monitor_network_usage.sh` runs periodically as a cron job and performs the following actions:
1. Checks if vnStat is installed and initializes the database for the specified network interface.
2. Updates the vnStat database.
3. Logs the current network usage statistics to the `network_usage.log` file in the `/reports` directory.

## Running the Container
1. Build the Docker image:
   ```bash
   docker build -t web_performance_measurement .
   ```
2. Run the Docker container:
   ```bash
   docker run -d --name web_performance_measurement web_performance_measurement
   ```

## Cron Jobs
The container sets up the following cron jobs:
- `web_perfomance_measuerement.sh`: Runs at 15 minutes past every hour.
- `monitor_network_usage.sh`: Runs daily at 23:55.

### Log Files
- Lighthouse performance metrics are saved in `/reports/lighthouse_report.csv`.
- Network usage statistics are recorded in `/reports/network_usage.log`.
- Cron job logs are available in `/var/log/cron.log`.

## Environment Variables
- `CHROME_PATH`: Path to the Chromium executable used by Lighthouse.

## Dependencies
- Node.js
- Chromium
- jq
- cron
- vnStat

Ensure these dependencies are installed in the container for the scripts to function correctly.
