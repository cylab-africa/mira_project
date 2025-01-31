# upz_packets_routes_africa

## Overview  
This container uses the `mtr` tool to perform traceroute measurements to 45 sites across Africa.  

## Setup  
1. Clone the repository and navigate to the container directory.  
2. Ensure the `IPs_data` file is present in the container directory.  

## Configuration  
To add a specific website or IP:  
1. Obtain the IP address and name of the website.  
2. Add the details to the `IPs_data` file in the following format:  


**Example**:  
localBank,192.168.1.10



## Usage  
1. Deploy the container to your target device.  
2. The service is scheduled to run at **00 minutes past the hour** to maximize pod efficiency.  
3. You can configure the timing in the Docker scheduler as needed.  
4. The traceroute results will be logged or saved as configured.
