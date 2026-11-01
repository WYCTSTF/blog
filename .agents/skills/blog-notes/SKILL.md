---
name: blog-notes
description: 维护本 Hexo 博客时使用——写/改文章、改 themes/plain 主题、改 _config.yml、写 scripts/ 构建期插件、新增页面、排查构建或发布异常。包含站点数据流、写作与主题约定、已知坑清单、验证命令，以及"改了什么必须同步更新哪些文档"的维护义务。
---

# 博客维护手册

`AGENTS.md` 是发布流程与硬性规则的唯一权威（`./publish.sh` 是唯一部署入口）。
本文件是干活用的细则：结构、约定、坑、验证、以及文档同步义务。

## 1. 站点速览

```
source/_posts/*.md ──┬→ scripts/fold-details.js   {% fold %} → <details>
                     ├→ scripts/toc.js            h2/h3 补 id，输出 page.toc
                     ├→ scripts/inline-css.js     style 构建期内联
                     └→ scripts/topics.js         topic_heatmap() / related_posts()
themes/plain/        layout/*.ejs + assets/style.css（唯一 CSS，约 3.5KB）
_config.yml          站点配置；主题配置在 themes/plain/_config.yml
publish.sh           hexo generate → 自检 → rsync 到 sg → git commit → push
```

硬约束：**零客户端 JS、零外部 CDN**。目录、折叠、热力图、相关笔记全部在构建期算完，
页面里只有内联 CSS 和 `<details>`。数学公式由 `@traptitech/markdown-it-katex` 输出 MathML。

## 2. 写文章

- `npx hexo new post "标题"` → 生成 `source/_posts/<slug>.md` + 同名资源目录
- front-matter 顺序：`title` / `date` / `tags` / `categories`（2 空格缩进，引用已有文案风格）
- `categories` 只能从 **算法 / 题解 / 工具链 / 计算机基础 / 杂谈 / Java** 里选一个
- `tags` 是纯数据（不进 UI），但要写，`Related` 靠它算
- 正文第一段后必须有 `<!-- more -->`，否则首页没有摘要
- 图片放 `source/_posts/<slug>/` 用相对路径（`post_asset_folder: true`）

## 3. 改主题

- UI 文案一律**英文**（Home / Archives / Categories / Topics / Read more / Newer / Older /
  Contents / Related / Tag: x / Category: x / Page N）；正文与业务内容用中文
- `<title>` / description / canonical / og 的兜底逻辑集中在 `_partial/head.ejs`，别的地方不要再拼
- 标签不作为导航：文章页与列表页都不输出 `#tag` 链接；标签只在 `related_posts()` 里用
- 新增 CSS 追加到 `themes/plain/assets/style.css` 末尾，注意样式是全站内联的（控制体积）
- 模板里能算的都在构建期算，不要为了一点点交互引入 JS

## 4. 已知坑（症状 → 原因 → 对策）

| 症状 | 原因 | 对策 |
|---|---|---|
| `hexo generate` 成功但生成 0 篇，`public/` 里出现 `.md` | `node_modules` 与 `package.json` 漂移，缺 `hexo-renderer-markdown-it`；`.md` 退化成静态资源，还会被 `db.json` 记成别的文章的 PostAsset | 改过 `package.json` 必须 `npm install`；`publish.sh` 会自检首页有没有文章 |
| WSL 执行 `./publish.sh` 报 `bash\r: No such file or directory` | 工作区脚本被检出成 CRLF | `.gitattributes` 已固定 `*.sh text eol=lf`，不要删 |
| `The source and destination cannot both be remote` | Git Bash 把 `/mnt/d/...` 改写成 `C:/Program Files/Git/mnt/...`，rsync 把盘符当远端 | `publish.sh` 已用 `MSYS2_ARG_CONV_EXCL='*' MSYS_NO_PATHCONV=1` |
| 用 Python 批量改 front-matter 后文章"消失" | `hexo-front-matter` 只认 **LF** 分隔符，写了 CRLF 就解析不出 | 改完必须 `hexo generate` 并核对篇数 |
| 标签/分类改了但页面 404，或标签莫名少几个 | 历史文件用单数 `tag:` / `category:` 键，只解析 `tags:` 的脚本会当空 | 迁移脚本要同时处理两种键，迁移后对比新旧标签集合差集 |
| 数学公式显示成纯文本，还出现奇怪的链接 | 公式块没包 `$$`（KaTeX 只认 `$…$` / `$$…$$`），裸 `\begin{align}` 会被 linkify | 块级公式一律 `$$` 包起来 |
| feed 里所有文章都显示"刚刚更新" | `updated_option: 'mtime'`，工作区 mtime 会被检出/同步改写 | 保持 `updated_option: 'date'`，真实更新时间手写 `updated` |
| 删过/重建过的 URL 一直 404，源站却是 200 | Cloudflare 把这个 zone 的 HTML 也缓存了（含 404） | 到后台 Purge 该 URL 或 Purge Everything |
| 菜单是英文但页面标题是中文 | 页面 front-matter 的 `title` 各自为政 | 页面标题跟菜单保持一致，改菜单时顺手改页面 title |

## 5. 验证

```bash
npm ci && npx hexo clean && npx hexo generate
grep -c '<article class="post">' public/index.html    # 首页有文章
find public -name '*.md' | wc -l                      # 必须 0
ls public/sitemap.xml public/robots.txt public/404.html public/topics/index.html
./publish.sh --dry-run                                # 构建 + rsync 预览，不上线
```

线上全量（应无任何非 200）：

```bash
curl -s https://blog.syh521.cn/sitemap.xml | grep -o '<loc>[^<]*' | cut -c6- \
  | while read -r u; do printf '%s %s\n' "$(curl -s -o /dev/null -w '%{http_code}' "$u")" "$u"; done \
  | grep -v '^200'
```

## 6. 维护义务（重要）

**改完不只是提交代码，还要让文档跟上。** 提交前按下表自检，并在同一个提交里更新：

| 这次改了什么 | 必须同步更新 |
|---|---|
| 新增/改变一条约定（命名、文案语言、分类集合、目录结构） | `AGENTS.md` 的相关条目 + 本文件对应章节 |
| 踩到新的坑（花超过 10 分钟才定位的） | 本文件 §4 表格追加一行（症状 / 原因 / 对策） |
| 改了发布链路（`publish.sh`、`.gitattributes`、nginx、CF 规则） | `AGENTS.md` 发布章节 + 本文件 §1/§4/§5 |
| 改了构建期脚本（`scripts/*.js`）或主题结构 | 本文件 §1 数据流图 + `README.md` 目录表 |
| 新增顶层目录、新页面类型 | `README.md` 目录表 + 本文件 §1 |
| 顺手发现文档与实现不一致 | **先修文档**，再提交代码；不要留"文档说要、代码不做"的矛盾 |

收尾自检三问：

1. 文档里描述的行为，代码真的这样做吗？（反例：`keywords` 配了但模板不输出、菜单英文但页面标题中文）
2. 新增的文件，`README.md` 的目录表认识它吗？
3. 这次踩的坑，三个月后的自己会在 §4 里找到吗？

历史背景（2026-11 那次大改造的体检结果与完整踩坑记录）见 `docs/refactor-2026-11.md`；
那份是一次性快照，**当前生效的规则以本文件与 `AGENTS.md` 为准**。
