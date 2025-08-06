const fs = require('fs');
const path = require('path');
const puppeteer = require('puppeteer');
const PuppeteerHar = require('puppeteer-har');

const WEBSITES_FILE = path.join(__dirname, 'websites');
const REPORTS_DIR = path.join(__dirname, '../reports');

// Load and clean website list
function cleanDomain(line) {
  let domain = line.trim();
  if (!domain || domain.startsWith('#')) return null;
  domain = domain.replace(/^(https?:\/\/)?(www\.)?/, '').split('/')[0];
  return domain;
}

const websites = fs.readFileSync(WEBSITES_FILE, 'utf-8')
  .split('\n')
  .map(cleanDomain)
  .filter(Boolean);

// Format timestamp in UTC: YYYY-MM-DD_HH
function formatUTCTimestampForFilename() {
  const now = new Date();
  const yyyy = now.getUTCFullYear();
  const mm = String(now.getUTCMonth() + 1).padStart(2, '0');
  const dd = String(now.getUTCDate()).padStart(2, '0');
  const hh = String(now.getUTCHours()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}_${hh}`;
}

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: process.env.CHROME_PATH || undefined,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });

  for (const domain of websites) {
    const url = `https://${domain}`;
    const page = await browser.newPage();
    const har = new PuppeteerHar(page);

    const timestamp = formatUTCTimestampForFilename();
    const domainShort = domain.split('.')[0]; // e.g. youtube from youtube.com
    const harPath = path.join(REPORTS_DIR, `${domainShort}_${timestamp}.har`);

    try {
      console.log(`Generating HAR for: ${url}`);
      await har.start({ path: harPath });
      await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 });
      await har.stop();
      console.log(`Saved HAR to ${harPath}`);
    } catch (err) {
      console.error(`Failed for ${domain}: ${err.message}`);
    } finally {
      await page.close();
    }
  }

  await browser.close();
})();
