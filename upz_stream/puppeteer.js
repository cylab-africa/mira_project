const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: '/usr/bin/chromium',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--autoplay-policy=no-user-gesture-required'
    ]
  });

  const page = await browser.newPage();

  page.on('console', msg => console.log(`[BROWSER] ${msg.text()}`));
  page.on('pageerror', err => console.error('[BROWSER ERROR]', err));

  await page.goto('file:///app/public/index.html', { waitUntil: 'load' });

  console.log("[INFO] Waiting 30 seconds for video playback and QoE metrics...");
  await new Promise(resolve => setTimeout(resolve, 30000));

  const qoe = await page.evaluate(() => {
    const video = document.querySelector('video');
    const quality = video.getVideoPlaybackQuality?.() || {};
    const droppedFrames = quality.droppedVideoFrames || video.webkitDroppedFrameCount || 0;
    const totalFrames = quality.totalVideoFrames || 0;

    const playbackStart = window.qoeMetrics.playbackStart ?? performance.now();
    const playbackEnd = window.qoeMetrics.playbackEnd ?? performance.now();
    const playbackDuration = (playbackEnd - playbackStart) / 1000;
    const bufferingRatio = window.qoeMetrics.bufferingTime / playbackDuration;

    return {
      ...window.qoeMetrics,
      totalStallTime: (window.qoeMetrics.stallEvents || []).reduce((a, b) => a + b, 0),
      playbackDuration,
      bufferingRatio,
      droppedFrames,
      totalFrames
    };
  });

  if (qoe) {
    console.log('📊 QoE Metrics:', qoe);

    const csvPath = '/app/reports/stream.csv';
    const timestamp = new Date().toISOString();
    const row = [
      timestamp,
      qoe.startupDelay ?? '',
      qoe.bufferingCount ?? '',
      qoe.bufferingTime ?? '',
      qoe.stallEvents.length ?? '',
      qoe.totalStallTime.toFixed(2) ?? '',
      qoe.bitrateChanges.length ?? '',
      qoe.playbackDuration.toFixed(2) ?? '',
      qoe.bufferingRatio.toFixed(4) ?? '',
      qoe.droppedFrames ?? '',
      qoe.totalFrames ?? ''
    ].join(',');

    if (!fs.existsSync(csvPath)) {
      fs.writeFileSync(csvPath, 'Timestamp,StartupDelay,BufferingCount,BufferingTime,StallEvents,TotalStallTime,BitrateSwitches,PlaybackDuration,BufferingRatio,DroppedFrames,TotalFrames\n');
    }

    fs.appendFileSync(csvPath, row + '\n');
  } else {
    console.log('⚠️ QoE Metrics: Not available');
  }

  await browser.close();
})();
