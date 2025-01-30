# upz_web_performance_measurement

## Overview  
This container performs web performance measurements on specified websites.  

## Setup  
1. Clone the repository and navigate to the container directory.  
2. Ensure the `websites` file is present in the container directory.  

## Configuration  
To modify the list of target websites:  
1. Open the `websites` file.  
2. Add or remove websites, ensuring one website per line.  
   **Example**:  
https://www.amazon.com
https://www.youtube.com
https://www.wikipedia.org

## Network Usage Monitoring
This container also includes a script to measure data usage and record the statistics in a file called `network_usage.log` inside the `/reports` folder.

The script `monitor_network_usage.sh` runs periodically as a cron job and logs the network usage of the specified interface.

### Log File
The network usage statistics are recorded in the `/reports/network_usage.log` file.
