# AGENTS.md — 给 AI 代理的仓库说明

Hexo 博客（themes/hexo-theme-landscape 子模块）。人类不直接操作 git 和部署，
由 AI 代理代劳。本文件是发布流程的唯一权威说明。

## 意图识别（核心）

用户说「写好了」「发布」「上传」「推上去」「更新博客」以及任何语义等价的表达
（不必逐字匹配），统一执行：

```bash
./publish.sh            # 可附自定义提交消息：./publish.sh "docs: 写了xxx"
```

脚本自包含：增量构建 → rsync 上线服务器 → git add -A + 自动生成 conventional
commit → push。全量约 6 秒，无变更约 2 秒（自动跳过提交）。`--dry-run` 只预览
不上线。执行后如实汇报结果（耗时、提交哈希、失败原因），**部署失败不得说成成功**。

## 提交消息由代理撰写（重要）

脚本的自动消息只是兜底（仅依据文件名，不可读）。**代理发布时若用户没有明确给出
提交消息，必须先看未提交变更（`git status --short` + `git diff`）概括内容**，
写一条具体、可读的中文 Conventional Commit 作为参数传入，例如：

```bash
./publish.sh "docs: 新增 hexo 本地 rsync 发布的踩坑记录"
```

描述要说清「改了什么内容」，不要写「更新文章」这类空话。主题子模块发布时
需概括改动点（如 `chore: 更新主题子模块，header 样式改用变量`）。

## 写作

- 新文章：`npx hexo new post "标题"`（生成 source/_posts/xxx.md）
- 本地实时预览：`npm run server`（http://localhost:4000）
- 草稿不发布就先别生成到正式目录

## 硬性规则

1. **不存在 `hexo deploy`**，不要尝试；部署唯一入口是 `./publish.sh`
2. **禁止 `git push --force`、`git reset --hard` 已推送的提交、`git push --delete`**——
   远端 master 是唯一备份，历史不可篡改
3. `scripts/` 是 Hexo 插件目录（里面所有文件会被当 JS 加载），shell 脚本一律放仓库根
4. 改主题（themes/hexo-theme-landscape）：先在子模块里提交并推送到 fork
   （git@github.com:WYCTSTF/hexo-theme-landscape.git），再回主仓库提交子模块指针，
   顺序不能反；`./publish.sh` 对此有警告
5. 提交消息用 Conventional Commits 中文描述（docs:/chore:/feat:/ci:）
6. header 高度等主题样式覆盖走 `scripts/header-css.js`（渲染时注入），
   不要改构建产物，不要加 CI sed 步骤
