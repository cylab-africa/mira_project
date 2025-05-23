# upz_streaming_qoe_monitor

## 📖 Overview

This container performs **video streaming Quality of Experience (QoE)** measurement using a DASH video player and **network usage monitoring** via `vnStat`.  
It logs key playback and network metrics into CSV and log files, enabling analysis and correlation between streaming behavior and network conditions.

---

## ⚙️ Setup

1. Clone the repository and navigate to the project directory:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```
2. Ensure the following files exist:
   - `Dockerfile`
   - `public/index.html` (dash.js-based test player)
   - `puppeteer.js` (headless browser script for QoE)
   - `monitor_network_usage.sh` (network stats logger)

---

## 🧪 Streaming QoE Measurement

The script `puppeteer.js` is scheduled via cron to run periodically. It:

1. Launches Chromium headlessly using Puppeteer.
2. Loads a DASH stream in a `dash.js`-based video player.
3. Captures key QoE metrics:
   - Startup delay
   - Buffering time and events
   - Stall durations
   - Bitrate switches
   - Dropped frames
   - Playback duration
   - Buffering ratio
4. Appends the results to `/app/reports/stream.csv`.

---

## 🌐 Network Usage Monitoring

The script `monitor_network_usage.sh` is also scheduled via cron. It:

1. Ensures `vnStat` is available and the database is initialized.
2. Logs network usage stats for the interface (default: `eth0`).
3. Appends results to `/app/reports/network_usage.log`.

---

## 🕒 Cron Jobs

The container currently runs both jobs **once per hour at minute 40**:

| Script                      | Schedule (CRON)       | Output File                             |
|-----------------------------|------------------------|------------------------------------------|
| `puppeteer.js`              | `40 * * * *`           | `/app/reports/stream.csv`               |
| `monitor_network_usage.sh`  | `40 * * * *`           | `/app/reports/network_usage.log`        |

> You can easily adjust the schedule by editing the cron expressions in the Dockerfile.

All output logs from cron are written to `/var/log/cron.log`.

---

## 📁 File Outputs

| File                             | Description                                  |
|----------------------------------|----------------------------------------------|
| `/app/reports/stream.csv`        | Streaming QoE results (CSV format)           |
| `/app/reports/network_usage.log` | Daily network usage log from vnStat          |
| `/var/log/cron.log`              | Output and error logs from cron jobs         |

---

## 🐳 Running the Container

1. **Build the Docker image**:
   ```bash
   docker build -t upz_streaming_qoe_monitor .
   ```

2. **Run the container**:
   ```bash
   docker run -d --name qoe_monitor upz_streaming_qoe_monitor
   ```

To stop:
```bash
docker stop qoe_monitor
docker rm qoe_monitor
```

---

## ⚙️ Environment Variables

| Variable                    | Description                                  |
|-----------------------------|----------------------------------------------|
| `PUPPETEER_EXECUTABLE_PATH` | Set to `/usr/bin/chromium` in Dockerfile     |

---

## 📦 Dependencies (preinstalled in Dockerfile)

- Node.js
- Chromium
- Puppeteer
- cron
- vnStat

---