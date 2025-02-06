# upz_mesh_routes

## Overview
This container performs traceroute measurements using the `mtr` tool to other devices in the experiment. The results are logged and saved for further analysis. Additionally, the container monitors network usage using `vnStat`.

## Setup
1. Clone the repository and navigate to the container directory:
   ```bash
   git clone <repository_url>
   cd upz_mesh_routes
   ```
2. Ensure the `IPs_data` file is available in the container directory. This file should contain the IP addresses and names of the devices to be traced.

## Configuration
To add a specific device or IP:
1. Obtain the IP address and name of the device.
2. Add the device details to the `IPs_data` file in the following format:
   ```plaintext
   deviceName,IP_Address
   ```
   **Example**:
   ```plaintext
   ispAPi,127.1.1.2
   ```

## Usage
1. Start the container using your preferred Docker setup or deployment platform (e.g., Balena):
   ```bash
   docker build -t upz_mesh_routes .
   docker run -d --name upz_mesh_routes -v $(pwd)/reports:/reports upz_mesh_routes
   ```
2. The service is scheduled to run at **40 minutes past the hour** to maximize pod efficiency. You can modify the scheduling in the Docker configuration if necessary.
3. The traceroute results will be logged in the `/reports` directory with filenames in the format `mtr_result_<current_datetime>.txt`.

## Scripts

### mtr_measurements.sh
This script performs traceroute measurements using the `mtr` tool. It reads the IP addresses from the `IPs_data` file and logs the results in the `/reports` directory.

### monitor_network_usage.sh
This script monitors network usage using `vnStat` and logs the usage statistics in the `/reports/network_usage.log` file.

## Dockerfile
The Dockerfile sets up the environment for running the `mtr` and `vnStat` tools, copies the necessary scripts and data files, and configures cron jobs to run the scripts at specified intervals.

### Key Sections:
- **Base Image**: Uses Ubuntu 20.04 as the base image.
- **Environment Variables**: Sets `DEBIAN_FRONTEND` to `noninteractive` to avoid interactive prompts during package installation.
- **Package Installation**: Installs necessary packages including `mtr`, `cron`, `geoip-bin`, and `vnStat`.
- **Directory Setup**: Creates `/reports` and `/scripts` directories.
- **Script Copying**: Copies the `mtr_measurements.sh`, `IPs_data`, and `monitor_network_usage.sh` scripts to the `/scripts` directory.
- **Permissions**: Sets executable permissions for the copied scripts.
- **Cron Jobs**: Configures cron jobs to run the `mtr_measurements.sh` script at 40 minutes past the hour and the `monitor_network_usage.sh` script at 23:55 daily.
- **Service Initialization**: Starts the `vnStat` service and runs cron in the foreground.

## Example IPs_data File
The `IPs_data` file should contain the IP addresses and names of the devices to be traced in the following format:
```plaintext
deviceName,IP_Address
```
**Example**:
```plaintext
airtelPi,197.157.186.122
mtnPi,41.186.78.1
liquidPi,41.216.98.178
```

## Logs and Reports
- **Traceroute Results**: Saved in the `/reports` directory with filenames in the format `mtr_result_<current_datetime>.txt`.
- **Network Usage**: Logged in the `/reports/network_usage.log` file.

## Contribution
Feel free to fork this repository, report issues, or submit pull requests. For significant changes, please open an issue first to discuss your ideas.

## License
This project is licensed under the MIT License. See the `LICENSE` file for more details.
