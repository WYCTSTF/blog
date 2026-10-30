// Inline the theme CSS at build time so pages never wait on a separate CSS request.
const fs = require('fs');
const path = require('path');

hexo.extend.helper.register('inline_css', function (relativePath) {
  const file = path.join(hexo.theme_dir, relativePath);
  if (!fs.existsSync(file)) {
    return '';
  }
  return fs.readFileSync(file, 'utf8');
});
