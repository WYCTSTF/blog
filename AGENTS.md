# AGENTS.md — 给 AI 代理的仓库说明

Hexo 博客（使用仓库内的极简主题 `themes/plain`）。人类不直接操作 git 和部署，
由 AI 代理代劳。本文件是发布流程的唯一权威说明。

前端约束：**不引入客户端 JS，不依赖外部 CDN**；数学公式在构建期转成 MathML；
新增功能优先服务端渲染（目录 `scripts/toc.js`、折叠 `scripts/fold-details.js` 都是
构建期产物）。

## 意图识别（核心）

用户说「写好了」「发布」「上传」「推上去」「更新博客」以及任何语义等价的表达
（不必逐字匹配），统一执行：

```bash
./publish.sh            # 可附自定义提交消息：./publish.sh "docs: 写了xxx"
```

脚本自包含：增量构建 → rsync 上线服务器 → git add -A + 自动生成 conventional
commit → push。全量约 6 秒，无变更约 2 秒（自动跳过提交）。`--dry-run` 只预览
不上线。执行后如实汇报结果（耗时、提交哈希、失败原因），**部署失败不得说成成功**。

环境：本机需要 `rsync`（Git Bash 默认没有，脚本会自动借 WSL 的 `/usr/bin/rsync`）。
所以 **`publish.sh` 必须保持 LF 行尾**（`.gitattributes` 已声明 `*.sh text eol=lf`），
CRLF 会让 WSL 里的 shebang 直接报 `bash\r: No such file or directory`。

脚本会在构建后自检 `public/index.html` 里有没有文章列表，0 篇直接报错退出（见下）。

## 提交消息由代理撰写（重要）

脚本的自动消息只是兜底（仅依据文件名，不可读）。**代理发布时若用户没有明确给出
提交消息，必须先看未提交变更（`git status --short` + `git diff`）概括内容**，
写一条具体、可读的中文 Conventional Commit 作为参数传入，例如：

```bash
./publish.sh "docs: 新增 hexo 本地 rsync 发布的踩坑记录"
```

描述要说清「改了什么内容」，不要写「更新文章」这类空话。改主题时概括改动点
（如 `chore: 主题 header 样式改用变量`）。

## 依赖（踩过的坑）

- **改过 `package.json` 必须 `npm install`**。依赖漂移时 Hexo 会把 `.md` 当成静态资源，
  模板渲染器缺失时 `hexo generate` 会「成功」输出 0 篇文章，还会把整批 `.md`
  复制进 `public/`。
- 不要装会引入客户端 JS 的插件；渲染器只保留 `hexo-renderer-ejs` + `hexo-renderer-markdown-it`。
- 换机器/CI 用 `npm ci`（`package-lock.json` 必须提交）。

## 写作约定

- 新文章：`npx hexo new post "标题"`（生成 `source/_posts/xxx.md` 与同名资源目录）
- front-matter 必须写全：`title` / `date` / `tags` / `categories`
  （分类只从 算法 / 题解 / 工具链 / 计算机基础 / 杂谈 / Java 里选）
- 正文必须有 `<!-- more -->`，否则首页只有标题没有摘要
- 标签（`tags`）**不作为导航 UI**：不再有标签总览页，标签只用于构建期生成文末「相关笔记」，
  正文/列表都不展示标签链接。主题入口是 `/topics/`（分类 × 季度的热力矩阵，构建期渲染），
  粒度可在 `themes/plain/_config.yml` 的 `heatmap.unit` 里改 `quarter`/`year`
- 图片放 `source/_posts/<同名目录>/` 里用相对路径引用（`post_asset_folder: true`）；
  不要写 `../images/xxx.png` 这类相对路径，站点根路径 `/images/xxx.png` 只服务
  `source/images/` 下的文件
- 本地实时预览：`npm run server`（http://localhost:4000）；草稿先别生成到正式目录

## 硬性规则

1. **不存在 `hexo deploy`**，不要尝试；部署唯一入口是 `./publish.sh`
2. **禁止 `git push --force`、`git reset --hard` 已推送的提交、`git push --delete`**——
   远端 master 是唯一备份，历史不可篡改
3. `scripts/` 是 Hexo 插件目录（里面所有文件会被当 JS 加载），shell 脚本一律放仓库根
4. 主题 `themes/plain` 直接在主仓库提交；旧主题 `themes/hexo-theme-landscape` 已从
   仓库移除（`.gitmodules` 已删），不要再引回来
5. 提交消息用 Conventional Commits 中文描述（docs:/chore:/feat:/fix:/ci:）
6. 不要重新引入客户端 JS / 外部 CDN（jQuery、fancybox、MathJax、搜索脚本等）；
   数学公式由 `@traptitech/markdown-it-katex` 在构建期输出 MathML
7. 构建产物里不应出现 `.md` 文件、`css/`、`js/`、`search.json`、`fancybox/`
   等旧主题残留；发布前可用 `grep -c 'article class="post"' public/index.html` 快速自检
8. `/tags/<tag>/` 页面仍然生成（保住老链接），但**没有任何入口**：不在菜单、不在 sitemap、
   文章和列表也不链接它；`/tags/` 由 nginx 301 到 `/topics/`
9. 改版背景与踩坑记录见 `docs/refactor-2026-11.md`（含可重复执行的验证命令）
