# 2026-11 改造总结

一次从「站点能看」到「链路能跑、结构自洽」的整理。记录当时的判断、踩过的坑和现在的约定，
避免半年后重新踩一遍。

> **这是一次性快照，不是规则来源。** 当前生效的约定、坑清单、验证命令与文档维护义务
> 在 `.agents/skills/blog-notes/SKILL.md`；发布流程在 `AGENTS.md`。
> 本文件只用来回看"当时为什么这么做"。

相关提交：`ea7bcd2`（SEO/内容治理）→ `cccb708`（主题页）→ `f50b7c5`（UI 文案回英文）
→ `8a0ed70`（补回丢失标签）。文档与收尾提交见 `git log --grep 改造`。

## 一、体检结论（改造前）

| 症状 | 证据 |
|---|---|
| 发布链路断 | `publish.sh` 是 CRLF，WSL 里 shebang 直接 `bash\r` 失败；Git Bash 里没有 `rsync` |
| 本地构建是坏的 | `node_modules` 里是 landscape 时代的 `hexo-renderer-marked/mathjax/pug/stylus`，缺 `hexo-renderer-markdown-it` → `hexo generate` **成功生成 0 篇文章** |
| 缓存库被污染 | 所有 `_posts/*.md` 被登记成第一篇文章的 `PostAsset`，`public/` 里多出 51 个裸 `.md` |
| 内容缺件 | 19 处图片引用里 **14 处**指向不存在的文件；3 个 `/file/*` 附件链接全断 |
| SEO 空白 | 无 description/og/canonical/sitemap/404/favicon，`description` 是空串 |
| 结构混乱 | 69/74 篇无分类；71 个标签里 50 个只用过一次；标签总览页只是 71 行 list |
| 遗留物 | landscape 子模块（dirty）、`_config.leedom.yml`、`bak/`、`delCodeXBranch.sh`；文档说"push 即上线"但实际是手动 rsync |

## 二、改了什么

**发布链路**：`.gitattributes` 强制 `*.sh eol=lf`；`publish.sh` 无 rsync 时借 WSL 的
`/usr/bin/rsync`（含 MSYS 路径转换处理）；构建后自检首页有没有文章；工作区无变更但有
未推送提交时也会 `git push`。

**SEO**：per-post description（正文摘要 120 字）+ canonical + og/twitter + 内联 SVG favicon
+ `hexo-generator-sitemap` + `robots.txt` + 自定义 404（nginx `error_page`）+
`trailing_index: false` + `updated_option: 'date'`。

**结构**：6 个分类全覆盖（题解 31 / 算法 17 / 工具链 12 / 计算机基础 9 / 杂谈 3 / Java 2）；
`/topics/` 用「分类 × 季度」热力矩阵取代标签总览页；标签退化为纯数据，只喂文末 `Related`
（标签重合 +10/个，无重合则同分类，按分数和日期取 3 篇）；文章正文前自动插 `Contents` 目录。

**内容**：74 篇补齐分类、补 `<!-- more -->`（7 篇）、统一 front-matter 顺序与缩进、
14 处失效图片换 `（图片缺失：xxx）` 标记、3 个死链改纯文本、1 处未包 `$$` 的
`\begin{align}` 修好。

**清理**：移除 landscape 子模块与 `.gitmodules`、旧主题配置、`bak/`、`delCodeXBranch.sh`；
重写 README/AGENTS。

## 三、踩过的坑（重点）

1. **Hexo 渲染器缺失是静默失败**：`.md` 不再被识别为文章，而是走 `processAsset`；
   Hexo 在 Windows 上 `post_asset_folder` 有 `path.sep` 拼接 bug，会把整批 `.md`
   挂到同一篇文章下并复制进 `public/`，同时把脏数据写进 `db.json`。
   → 对策：`publish.sh` 构建后 `grep '<article class="post">' public/index.html`，
   0 篇直接退出；改过 `package.json` 必须 `npm install`。

2. **CRLF 会杀死 shebang**：`core.autocrlf=true` 且无 `.gitattributes` 时，WSL 执行
   `./publish.sh` 报 `bash\r: No such file or directory`。

3. **Git Bash 会改写传给 Windows 程序的路径**：`/mnt/d/...` 变 `C:/Program Files/Git/mnt/d/...`，
   rsync 把带盘符的源当成远端，报 `The source and destination cannot both be remote`。
   → `MSYS2_ARG_CONV_EXCL='*' MSYS_NO_PATHCONV=1`。

4. **`hexo-front-matter` 只认 LF 分隔符**。用 Python 批量改 front-matter 时按 `\r\n` 原样写回，
   文章当场"消失"（解析失败被跳过）。改完必须用 `hexo-front-matter` 或构建结果验证篇数。

5. **单数 `tag:` / `category:` 键**：`tag:` 是 Hexo 的兼容写法，只解析 `tags:` 的脚本会把它当空。
   这次因此丢了 `权值线段树`、`动态开点` 两个标签，旧标签页 404，事后才发现。
   → 迁移脚本要同时处理两种键，且迁移后对比"标签集合差集"。

6. **KaTeX 只处理 `$…$` / `$$…$$`**：裸 `\begin{align}` 会当纯文本输出，还会被 linkify 出
   `p_i.w-p_{i-1}.w` 这种假链接。

7. **`updated_option: 'mtime'` 不可靠**：工作区 mtime 会被检出/同步改写，导致 feed 里
   所有文章都显示"刚刚更新"。改用 `'date'`，需要真实更新时间就在 front-matter 手写。

8. **Cloudflare 会缓存 404**：这个 zone 连 HTML 都缓存（`cf-cache-status: HIT` 且
   `Cache-Control: no-store` 同时出现）。删除后又重建的 URL 会继续返回旧的 404，
   必须 Purge（这次 Purge Everything 解决）。

## 四、现在的结构

```
source/_posts/*.md ──┬─→ scripts/fold-details.js   {% fold %} → <details>
                     ├─→ scripts/toc.js            h2/h3 补 id + page.toc
                     ├─→ themes/plain/*.ejs        head/post/index/archive/topics…
                     └─→ scripts/topics.js         topic_heatmap() / related_posts()

publish.sh = hexo generate → 自检 → rsync(sg:/var/www/blog/public/) → git add -A
             → commit(如无消息则按文件名兜底) → push(有未推送提交就推)
```

约束：**零客户端 JS、零外部 CDN**，所有交互（目录、折叠、热力图、相关笔记）都在构建期算完。

## 五、当前约定（会一直生效）

- UI 文案一律英文（Home/Archives/Categories/Topics/Read more/Newer/Older/Contents/Related），
  正文和页面内容用中文
- `categories` 只能从 6 个里选；`tags` 不暴露在 UI 上，只用于 `Related`
- 正文必须有 `<!-- more -->`；图片放 `source/_posts/<同名目录>/` 用相对路径
- `/tags/` 301 → `/topics/`；`/tags/<tag>/` 仍然生成（保住老链接），但没有任何入口、
  不进 sitemap、不进菜单
- 分类/标签/归档/分页页的 `<title>` 由 `head.ejs` 统一兜底（`Tag: x`、`Category: x`、`Page N`）

## 六、怎么验证（可重复执行）

```bash
npm ci && npx hexo clean && npx hexo generate
grep -c '<article class="post">' public/index.html    # 首页有文章
find public -name '*.md' | wc -l                      # 必须是 0
ls public/sitemap.xml public/robots.txt public/404.html public/topics/index.html

./publish.sh --dry-run                                # 构建 + rsync 预览，不上线

# 线上全量：sitemap 里的 URL 与全部标签页都应 200
curl -s https://blog.syh521.cn/sitemap.xml | grep -o '<loc>[^<]*' | cut -c6- \
  | while read -r u; do printf '%s %s\n' "$(curl -s -o /dev/null -w '%{http_code}' "$u")" "$u"; done \
  | grep -v '^200'
```

## 七、遗留

- **14 张图片**：`（图片缺失：xxx）` 标记还在原位，原图在本仓库/git 历史/旧 GitHub Pages/
  Wayback 里都不存在，只能自己重新截图或补图
- **Series（阅读路径）**：17 篇算法 + 3 篇 CSAPP 本来是课程结构，现在只有分类没有顺序，
  想做得再加 `series` + `order` front-matter
- **CF 缓存策略**：现在 HTML 也走边缘缓存，改版后可能要 Purge；更合理的是
  「HTML 不缓存 / 静态资源长缓存」的 Cache Rule
- **`/tags/<tag>/` 的 SEO 处置**：目前是孤儿页（无入口、不进 sitemap），若担心被爬，
  可以在 `head.ejs` 给 `page.tag` 加 `noindex`
- **`feed` 未显式配置**：`atom.xml` 用默认 20 条全文，想改 limit 就在 `_config.yml` 加 `feed:`
- **标题层级**：列表页（首页/归档/分类/主题）没有 `h1`；文章正文里作者惯用 `#` 当小节，
  导致文章页有多个 `h1`。只修了 `presentations` 页「标题 + 正文 h1」重复的问题，
  其余没动——统一改会动到 74 篇的锚点和目录，收益不抵风险
