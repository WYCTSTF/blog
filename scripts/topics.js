// 主题 × 时间 热力矩阵 + 相关笔记。全部构建期算好，输出纯 HTML（零客户端 JS）。
const MAX_LEVEL = 4;

// 时间粒度：quarter（默认，Q1-Q4）或 year。粒度在主题 _config.yml 里配。
function unitOf(theme) {
  const unit = theme && theme.heatmap && theme.heatmap.unit;
  return unit === 'year' ? 'year' : 'quarter';
}

// key 序号：年粒度 = year，季粒度 = year*4 + quarter(0-3)
function keyOf(date, unit) {
  return unit === 'year' ? date.year() : date.year() * 4 + Math.floor(date.month() / 3);
}

// 「分类 × 时间」矩阵：行是分类，列是时间，色阶是文章数
hexo.extend.helper.register('topic_heatmap', function () {
  const url_for = this.url_for;
  const unit = unitOf(this.theme);
  const posts = this.site.posts.sort('date').toArray();
  if (!posts.length) return '';

  const first = posts[0].date;
  const last = posts[posts.length - 1].date;
  const firstKey = keyOf(first, unit);
  const lastKey = keyOf(last, unit);

  const cells = [];
  for (let key = firstKey; key <= lastKey; key++) {
    cells.push(unit === 'year'
      ? { key, label: String(key) }
      : { key, label: `Q${(key % 4) + 1}`, year: Math.floor(key / 4) });
  }

  // 分类按文章数从多到少
  const cats = this.site.categories
    .toArray()
    .map((cat) => ({ name: cat.name, path: cat.path, count: cat.posts.length, posts: cat.posts.toArray() }))
    .sort((a, b) => b.count - a.count || a.name.localeCompare(b.name));

  const grid = new Map();
  let max = 1;
  for (const cat of cats) {
    const row = new Map();
    for (const post of cat.posts) {
      const key = keyOf(post.date, unit);
      const n = (row.get(key) || 0) + 1;
      row.set(key, n);
      if (n > max) max = n;
    }
    grid.set(cat.name, row);
  }
  const step = Math.ceil(max / MAX_LEVEL);
  const level = (n) => (n === 0 ? 0 : Math.min(MAX_LEVEL, Math.ceil(n / step)));

  // 表头：年粒度直接是年份；季粒度上排年份（每 4 格合并）、下排 Q1-Q4
  let head;
  if (unit === 'year') {
    head = `<div class="hm-corner"></div>${cells.map((c) => `<div class="hm-year">${c.label}</div>`).join('')}`;
  } else {
    const years = [];
    for (const c of cells) {
      const tail = years[years.length - 1];
      if (tail && tail.year === c.year) tail.span += 1;
      else years.push({ year: c.year, span: 1 });
    }
    const yearCells = years
      .map((y) => `<div class="hm-year" style="grid-column: span ${y.span}">${y.year}</div>`)
      .join('');
    const quarterCells = cells.map((c) => `<div class="hm-q">${c.label}</div>`).join('');
    head = `<div class="hm-corner"></div>${yearCells}<div class="hm-corner"></div>${quarterCells}`;
  }

  const rows = cats
    .map((cat) => {
      const row = grid.get(cat.name);
      const dots = cells
        .map((c) => {
          const n = row.get(c.key) || 0;
          const when = unit === 'year' ? c.label : `${c.year} ${c.label}`;
          const tip = `${when} · ${cat.name} · ${n} 篇`;
          return `<span class="hm-c l${level(n)}" title="${tip}"></span>`;
        })
        .join('');
      return `<a class="hm-row" href="${url_for(cat.path)}">${cat.name}<span class="count">${cat.count}</span></a>${dots}`;
    })
    .join('');

  const legend = Array.from({ length: MAX_LEVEL }, (_, i) => `<span class="hm-c l${i + 1}"></span>`).join('');
  const span = `${first.format('YYYY-MM')} → ${last.format('YYYY-MM')}`;

  return `<div class="hm">
  <div class="hm-scroll">
    <div class="hm-grid" style="--cols:${cells.length}">
      ${head}
      ${rows}
    </div>
  </div>
  <p class="hm-legend"><span class="hm-legend-label">少</span>${legend}<span class="hm-legend-label">多</span><span class="hm-legend-note">共 ${posts.length} 篇 · ${span}</span></p>
</div>`;
});

// 相关笔记：标签重合优先，其次同分类，最近更新靠前
hexo.extend.helper.register('related_posts', function (page, limit) {
  limit = limit || 3;
  const names = (list) => (list && list.toArray ? list.toArray().map((x) => x.name) : []);
  const myTags = new Set(names(page.tags));
  const myCats = new Set(names(page.categories));

  const scored = [];
  for (const post of this.site.posts.toArray()) {
    if (post._id === page._id) continue;
    let score = 0;
    for (const tag of names(post.tags)) {
      if (myTags.has(tag)) score += 10;
    }
    if (score === 0) {
      for (const cat of names(post.categories)) {
        if (myCats.has(cat)) {
          score += 1;
          break;
        }
      }
    }
    if (score > 0) scored.push({ post, score });
  }

  scored.sort((a, b) => b.score - a.score || b.post.date - a.post.date);
  return scored.slice(0, limit).map((item) => item.post);
});
