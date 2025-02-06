# UPZ Packets Routes Africa

## Overview
This project leverages the `mtr` tool to perform traceroute measurements to various sites across Africa. The container also monitors network usage using `vnStat`.

## Setup
1. Clone the repository and navigate to the container directory:
    ```bash
    git clone <repository_url>
    cd mira_project-1/upz_packets_routes_africa
    ```
2. Ensure the `IPs_data` file is present in the container directory.

## Configuration
To add a specific website or IP:
1. Obtain the IP address and name of the website.
2. Add the details to the `IPs_data` file in the following format:
    ```csv
    website_name,ip_address
    ```
    **Example**:
    ```csv
    localBank,192.168.1.10
    ```

## Usage
1. Build and deploy the container to your target device:
    ```bash
    docker build -t upz_packets_routes_africa .
    docker run -d --name upz_packets_routes_africa upz_packets_routes_africa
    ```
2. The `mtr_measurements.sh` script is scheduled to run at **00 minutes past the hour** to perform traceroute measurements.
3. The `monitor_network_usage.sh` script is scheduled to run daily at **23:55** to log network usage.
4. You can configure the timing in the Docker scheduler as needed by modifying the `crontab` entries in the Dockerfile.

## Output
- Traceroute results are saved in the `/reports` directory with filenames in the format `mtr_result_<timestamp>.txt`.
- Network usage logs are saved in the `/reports/network_usage.log` file.

## Technical Details
- **Base Image**: Ubuntu 20.04
- **Tools Used**:
  - `mtr`: Network diagnostic tool that combines the functionality of `traceroute` and `ping`.
  - `vnStat`: Network traffic monitor for Linux.
  - `geoiplookup`: Tool to find the geographical location of an IP address.
- **Scripts**:
  - `mtr_measurements.sh`: Runs `mtr` for each IP in the `IPs_data` file and logs the results.
  - `monitor_network_usage.sh`: Logs network usage statistics using `vnStat`.

## Example Output
**Traceroute Results**:
```
Running mtr for IP:81.192.44.66 site:iam.ma country: Morocco. date:2023-10-01_12-00PM
HOST: myhost                       Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    192.168.1.1           0.0%     3    0.5   0.5   0.5   0.5   0.0
  2. AS???    10.0.0.1              0.0%     3    1.0   1.0   1.0   1.0   0.0
  ...
```

**Network Usage Log**:
```
2023-10-01 23:55: Network usage for interface eth0
 rx:  1.23 GiB      tx:  456.78 MiB
---------------------------------
```

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
