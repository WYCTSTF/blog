# Blog

个人博客源码（Hexo），线上地址 <https://blog.syh521.cn>。

- 主题：`themes/plain`（仓库内，零客户端 JS、零外部 CDN，数学公式构建期转 MathML）
- 部署：本地构建 + `rsync` 到服务器，**没有 `hexo deploy`**

## 发布

```bash
./publish.sh                          # 构建 → rsync 上线 → git 提交并 push
./publish.sh "docs: 写了 xxx"          # 带自定义提交消息
./publish.sh --dry-run                # 只构建 + 预览 rsync 差异，不上线不提交
```

需要 `rsync`：Git Bash 没有时会自动借 WSL 的 rsync。脚本必须保持 LF 行尾
（`.gitattributes` 已声明）。

## 本地开发

```bash
npm ci            # 首次 / 换机器（改过 package.json 后必须重装依赖）
npm run server    # http://localhost:4000 实时预览
npm run build     # 只生成到 public/
```

## 写文章

```bash
npx hexo new post "标题"     # 生成 source/_posts/标题.md + 同名资源目录
```

front-matter 至少包含 `title` / `date` / `tags` / `categories`，正文里加
`<!-- more -->` 作为首页摘要分隔。完整约定见 [AGENTS.md](AGENTS.md)。

## 目录

| 路径 | 说明 |
|---|---|
| `source/_posts/` | 文章（`post_asset_folder: true`，图片放同名目录） |
| `source/` 其余 | 独立页面：categories / **topics（主题热力图）** / links / presentations / feeds / 404 |
| `themes/plain/` | 主题模板 + 内联 CSS |
| `scripts/` | Hexo 构建期插件（TOC、折叠、CSS 内联、主题热力图、相关笔记） |
| `publish.sh` | 唯一发布入口 |
| `docs/` | 改造记录与踩坑（`refactor-2026-11.md`） |
