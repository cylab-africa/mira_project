# Upanzi Pod Measurements - Version 4.3

The Upanzi Pod Measurements project is designed to perform a variety of network measurements across different locations and configurations. The goal is to monitor network performance, measure resource usage, and provide insights into network routes and web performance. This version integrates multiple services running in Docker containers, scheduled to optimize resource usage and ensure efficiency.

---

## Features

### Services
The following services are included in the Upanzi Pod:

- **speedtest_test**: Measures network speed using Ookla Speedtest and iPerf3.
- **packets routes for Africa Sites**: Performs traceroutes to 45 African websites.
- **packets routes for between the devices (MESH)**: Traces routes between devices in the pod.
- **web performance measurements**: Analyzes the performance of specified websites.
- **net usage monitoring**: Tracks the network usage of all containers on the device.

---

## Service Runtime Schedule

To maximize efficiency, services are scheduled to run at specific times each hour:

- **@00 Minutes**: Packets routes for Africa Sites.
- **@15 Minutes**: Web performance measurements.
- **@25 Minutes**: Speedtest_test. (This timing can be modified as needed.)
- **@40 Minutes**: Packets routes between devices (MESH).
- **@55 Minutes**: Net usage monitoring.

---

## Environmental Variables

You can customize the configuration for speed tests through the following environmental variables. These variables can be modified directly in Balena Cloud:

- `ENV ookla_speedtest=false` to enable/disable Ookla Speedtest.
- `ENV iperf3_speedtest=false` to enable/disable iPerf3 Speedtest.
- `ENV iperf3_server="<IP_ADDRESS>"` to set the iPerf server.
- `ENV ookla_server="<IP_ADDRESS>"` to specify the Ookla server.

---

## Usage Instructions

### Getting Started

1. Clone this repository to your local machine.
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

  africa_routes:
    build: ./upz_packets_routes_africa

  web_performance:
    build: ./upz_web_performance_measurement

  network_usage:
    build: ./upz_network_usage_monitor
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

- [Speedtest Service](./upz_speed_test/README.md)
- [Mesh Routes Service](./upz_mesh_routes/README.md)
- [Africa Routes Service](./upz_packets_routes_africa/README.md)
- [Web Performance Service](./upz_web_performance_measurement/README.md)
- [Network Usage Monitoring Service](./upz_network_usage_monitor/README.md)

---

## Contribution

Feel free to fork this repository, report issues, or submit pull requests. For significant changes, please open an issue first to discuss your ideas.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
