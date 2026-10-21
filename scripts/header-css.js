// 渲染后注入一行 CSS：把 header 高度从主题默认的 300px 改为 200px。
// 替代旧的 CI sed hack（直接改 public/css/style.css 产物）。
// 主题的 banner-height 定义在 themes/hexo-theme-landscape/source/css/_variables.styl，
// 主题本身不支持注入机制，故在博客仓库层面用 filter 覆盖；
// 注入点位于 </head> 前（style.css 之后），同特异性下后者胜。
hexo.extend.filter.register('after_render:html', html =>
  html.replace('</head>', '<style>#header{height:200px}</style></head>')
);
