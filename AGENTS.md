# AGENTS.md — 给 AI 代理的仓库说明

Hexo 博客（使用仓库内的极简主题 `themes/plain`）。人类不直接操作 git 和部署，
由 AI 代理代劳。本文件是发布流程的唯一权威说明。

前端约束：**不引入客户端 JS，不依赖外部 CDN**；数学公式在构建期转成 MathML；
新增功能优先服务端渲染（目录 `scripts/toc.js`、折叠 `scripts/fold-details.js` 都是
构建期产物）。

> 本文件只写"发布与提交"的行为约束。站点结构、写文章/改主题约定、已知坑清单、
> 验证命令、以及**改动后要同步更新哪些文档**，都在 `.agents/skills/blog-notes/SKILL.md`。
> 动手改文章/主题/配置/脚本前先读它；提交前按它第 6 节自检。`CLAUDE.md` 是入口索引。

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

脚本会在构建后自检 `public/index.html` 里有没有文章列表，0 篇直接报错退出（通常是依赖漂移，见规则 8）。

## 提交消息由代理撰写（重要）

脚本的自动消息只是兜底（仅依据文件名，不可读）。**代理发布时若用户没有明确给出
提交消息，必须先看未提交变更（`git status --short` + `git diff`）概括内容**，
写一条具体、可读的中文 Conventional Commit 作为参数传入，例如：

```bash
./publish.sh "docs: 新增 hexo 本地 rsync 发布的踩坑记录"
```

描述要说清「改了什么内容」，不要写「更新文章」这类空话。改主题时概括改动点
（如 `chore: 主题 header 样式改用变量`）。

## 细则

写文章、改主题、改配置、写构建期脚本、排查构建/发布异常 → 先读
`.agents/skills/blog-notes/SKILL.md`（含速览、约定、坑、验证、文档维护义务），
不要在别处另记一份，避免两套说法打架。

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
8. **改过 `package.json` 必须 `npm install`**（依赖漂移会让构建静默生成 0 篇）
9. `/tags/<tag>/` 页面仍然生成（保住老链接），但**没有任何入口**：不在菜单、不在 sitemap，
   文章和列表也不链接它；`/tags/` 由 nginx 301 到 `/topics/`
10. 改完必须按 `.agents/skills/blog-notes/SKILL.md` 第 6 节同步文档，同一提交内完成；
    历史背景见 `docs/refactor-2026-11.md`（一次性快照，不作规则来源）
