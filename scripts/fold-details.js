// Render {% fold title %}...{% endfold %} as native <details>, no client-side JS.
hexo.extend.tag.register('fold', (args, content) => {
  const title = args.join(' ').trim();
  const body = hexo.render.renderSync({ text: content, engine: 'markdown' }) || '';
  return `<details><summary>${title}</summary>\n${body}\n</details>`;
}, { ends: true });
