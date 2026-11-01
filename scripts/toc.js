// 构建期生成文章目录：给 h2/h3 补 id，并在正文前插入目录。
// 仍然零客户端 JS，不依赖任何 CDN。
const { stripHTML } = require('hexo-util');

function slugify(text, used) {
  let base = text
    .toLowerCase()
    .replace(/[^\w\u4e00-\u9fff\- ]+/g, '')
    .trim()
    .replace(/\s+/g, '-');
  if (!base) base = 'section';
  let id = base;
  let n = 2;
  while (used.has(id)) id = `${base}-${n++}`;
  used.add(id);
  return id;
}

hexo.extend.filter.register('after_post_render', function (data) {
  if (data.layout !== 'post' || !data.content) return data;

  const used = new Set();
  const items = [];

  data.content = data.content.replace(
    /<h([23])(\s[^>]*)?>([\s\S]*?)<\/h\1>/g,
    (match, level, attrs, inner) => {
      // MathML 输出里 <annotation> 是 TeX 源码副本，去掉否则标题文字会重复一遍
      const text = stripHTML(inner.replace(/<annotation[\s\S]*?<\/annotation>/g, '')).trim();
      if (!text) return match;
      attrs = attrs || '';
      const existing = /id="([^"]+)"/.exec(attrs);
      let id;
      if (existing) {
        id = existing[1];
        used.add(id);
      } else {
        id = slugify(text, used);
        attrs += ` id="${id}"`;
      }
      items.push({ level: Number(level), id, text });
      return `<h${level}${attrs}>${inner}</h${level}>`;
    }
  );

  if (items.length < 3) {
    data.toc = '';
    return data;
  }

  const list = items
    .map((i) => `<li class="toc-h${i.level}"><a href="#${i.id}">${i.text}</a></li>`)
    .join('');

  data.toc = `<nav class="toc">\n<p class="toc-title">Contents</p>\n<ul>${list}</ul>\n</nav>`;
  return data;
});
