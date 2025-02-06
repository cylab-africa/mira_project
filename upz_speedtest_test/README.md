# upz_speed_test

## Overview  
This container performs performance tests using `ookla speedtest` and `iperf3`.  

## Setup  
1. Clone the repository and navigate to the container directory:
    ```sh
    git clone <repository_url>
    cd <repository_directory>
    ```
2. Deploy the container to your target device using Docker or Balena:
    - **Docker**:
        ```sh
        docker build -t upz_speed_test .
        docker run -d --name upz_speed_test upz_speed_test
        ```
    - **Balena**:
        Follow the instructions on the [Balena documentation](https://www.balena.io/docs/).

## Configuration  
Environmental variables can be modified in Balena Cloud or in the Docker environment:
- **Ookla Speedtest**:  
  - `ENV ookla_speedtest=false` to enable Ookla Speedtest.  
  - `ENV ookla_server="none"` to specify an Ookla server (optional).  
- **iPerf3 Speedtest**:  
  - `ENV iperf3_speedtest=false` to enable iPerf3 Speedtest.  
  - `ENV iperf3_server="169.150.238.161"` to set the iPerf3 server.  

You can change the server IP or enable/disable specific speed tests by modifying these variables.  

## Usage  
1. The service is scheduled to run at **25 minutes past the hour** to maximize pod efficiency.  
2. You can modify the scheduling in the Docker configuration if necessary.
3. After deployment, the container will run the configured performance tests.
4. Logs and results will be stored in the `/reports` directory inside the container.

## Logs and Reports
- Speedtest results will be saved as JSON files in the `/reports` directory.
- iPerf3 results will be saved as text files in the `/reports` directory.
- Network usage logs will be saved in `/reports/network_usage.log`.

## Troubleshooting
- Ensure that `vnStat` is installed and running in the container.
- Check the logs in `/var/log/cron.log` for any errors or issues.
