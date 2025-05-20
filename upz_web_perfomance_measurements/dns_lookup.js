const dns = require('dns').promises;
const { performance } = require('perf_hooks');
const fs = require('fs');
const path = require('path');

const WEBSITES_FILE = path.join(__dirname, 'websites');
const LOG_FILE = path.join(__dirname, '../reports/dns_lookup_log.csv');

// Helper function to sanitize input into a valid domain
function cleanDomain(line) {
  let domain = line.trim();
  if (!domain || domain.startsWith('#')) return null;

  // Remove protocol and path
  domain = domain.replace(/^(https?:\/\/)?(www\.)?/, '').split('/')[0];
  return domain;
}

// Load and clean website list
const websites = fs.readFileSync(WEBSITES_FILE, 'utf-8')
  .split('\n')
  .map(cleanDomain)
  .filter(Boolean);

// Write CSV header if file does not exist
if (!fs.existsSync(LOG_FILE)) {
  fs.writeFileSync(LOG_FILE, 'site,dnslookuptime,experiment_runtime\n');
}

(async () => {
  for (const domain of websites) {
    const timestamp = new Date().toISOString();
    try {
      const start = performance.now();
      await dns.lookup(domain);
      const end = performance.now();
      const lookupTime = (end - start).toFixed(2); // in ms

      console.log(`${domain}: ${lookupTime} ms`);
      fs.appendFileSync(LOG_FILE, `${domain},${lookupTime},${timestamp}\n`);
    } catch (err) {
      console.error(`Failed to resolve ${domain}:`, err.message);
      fs.appendFileSync(LOG_FILE, `${domain},N/A,${timestamp}\n`);
    }
  }
})();
