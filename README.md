# Upanzi Pod Measurements - Version 4.3

The Upanzi Pod Measurements project is designed to perform a variety of network measurements across different locations and configurations. The goal is to monitor network performance, measure resource usage, and provide insights into network routes and web performance. This version integrates multiple services running in Docker containers, scheduled to optimize resource usage and ensure efficiency.

---

## Features

### Services
The following services are included in the Upanzi Pod:

- **Speedtest Service**: Measures network speed using Ookla Speedtest and iPerf3.
- **Africa Routes Service**: Performs traceroutes to 45 African websites.
- **Mesh Routes Service**: Traces routes between devices in the pod.
- **Web Performance Service**: Analyzes the performance of specified websites.
- **Network Usage Monitoring**: Tracks the network usage of all containers on the device. (Now included within each service)

---

## Service Runtime Schedule

To maximize efficiency, services are scheduled to run at specific times each hour (This timing can be modified as needed.):

- **@00 Minutes**: Africa Routes Service.
- **@15 Minutes**: Web Performance Service.
- **@25 Minutes**: Speedtest Service. 
- **@40 Minutes**: Mesh Routes Service.

**Note**: All times are in UTC. Ensure to coordinate accordingly to your local time.

---

## Environmental Variables

You can customize the configuration for speed tests through the following environmental variables. These variables can be modified directly in Balena Cloud:

- `ENV ookla_speedtest=false` to enable/disable Ookla Speedtest.
- `ENV iperf3_speedtest=false` to enable/disable iPerf3 Speedtest.
- `ENV iperf3_server="<IP_ADDRESS>"` to set the iPerf server.
- `ENV ookla_server="<IP_ADDRESS>"` to specify the Ookla server.
- `ENV IP_LIST="deviceName1,IP_Address1;deviceName2,IP_Address2;deviceName3,IP_Address3;"` to specify the list of IP addresses for the Mesh Routes Service.

**Example**:
```plaintext
ENV IP_LIST="airtelPi,197.157.186.122;mtnPi,41.186.78.1;liquidPi,41.216.98.178;"
```

---

## Usage Instructions

### Getting Started

1. Clone this repository to your local machine:
   ```bash
   git clone <repository_url>
   ```
2. Navigate to the repository folder:
   ```bash
   cd upanzi-pod-measurements
   ```

### Running the Project

To deploy all the containers as a pod, you can use a `docker-compose.yml` file. Here is an example setup for Balena:

#### Example `docker-compose.yml`
```yaml
version: '2.1'
services:
  speedtest:
    build: ./upz_speed_test
    environment:
      - ookla_speedtest=false
      - iperf3_speedtest=false
      - iperf3_server=169.150.238.161
      - ookla_server=none

  mesh_routes:
    build: ./upz_mesh_routes
    environment:
      - IP_LIST=airtelPi,197.157.186.122;mtnPi,41.186.78.1;liquidPi,41.216.98.178;

  africa_routes:
    build: ./upz_packets_routes_africa

  web_performance:
    build: ./upz_web_performance_measurement
```

### Deploying on Balena

1. Log in to your Balena Cloud account.
2. Create a new fleet and add your device.
3. Push the project to your Balena Cloud:
   ```bash
   balena push <your_fleet_name>
   ```
4. Verify that all services are running from the Balena Cloud dashboard.

---

## Additional Documentation

Each service has a detailed README file for further instructions. Click on the links below for more information:

- [Speedtest Service](./upz_speedtest_test/README.md)
- [Mesh Routes Service](./upz_mesh_routes/README.md)
- [Africa Routes Service](./upz_packets_routes_Africa/README.md)
- [Web Performance Service](./upz_web_perfomance_measurements/README.md)

---

## Contribution

Feel free to fork this repository, report issues, or submit pull requests. For significant changes, please open an issue first to discuss your ideas.

---

## License

This project is licensed under the Mozilla Public License 2.0 (MPL-2.0). See the [`LICENSE`](https://www.mozilla.org/en-US/MPL/2.0/) file for more details.