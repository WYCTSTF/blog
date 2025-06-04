const fs = require('fs');
const assert = require('assert');

const config = fs.readFileSync('_config.yml', 'utf8');
assert(/title:\s*.+/.test(config), 'title not found in _config.yml');
assert(/theme:\s*.+/.test(config), 'theme not found in _config.yml');
console.log('All config checks passed.');
