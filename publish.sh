#!/usr/bin/env bash
# 一条命令发布博客：增量构建 → rsync 上线 → git 归档（后台账本，不再是发布门槛）
# 用法: ./publish.sh [commit 消息]     完整发布
#       ./publish.sh --dry-run         只构建 + rsync 预览，不上线不提交
#
# 环境要求：Git Bash（需要 rsync）或任意带 rsync 的 POSIX shell；
# Windows Git Bash 没有 rsync 时会自动借 WSL 里的 rsync 上传。
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"
REMOTE="sg:/var/www/blog/public/"
RSYNC_OPTS=(--delete --exclude=/.well-known/ --chown=blogdeploy:blogdeploy)

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY=1; shift
else
  DRY=0
fi
MSG="${*:-}"

# ---- rsync 定位：本机有就用本机，没有就借 WSL（Windows 下 Git Bash 通常没有）----
SRC="$PWD/public/"
USE_WSL=0
if ! command -v rsync >/dev/null 2>&1; then
  if command -v wsl.exe >/dev/null 2>&1 || command -v wsl >/dev/null 2>&1; then
    win_path=$(pwd -W 2>/dev/null || pwd)
    wsl_path=$(printf '%s' "$win_path" | sed -E 's#^([A-Za-z]):#/mnt/\L\1#')
    SRC="$wsl_path/public/"
    USE_WSL=1
    echo "==> 本机无 rsync，改用 WSL: $SRC"
  else
    echo "❌ 找不到 rsync：请安装 rsync（MSYS2: pacman -S rsync）或使用 WSL 执行" >&2
    exit 1
  fi
fi

# MSYS2_ARG_CONV_EXCL 必须置空：否则 Git Bash 会把 /mnt/d/... 改写成
# C:/Program Files/Git/mnt/...，rsync 会把带盘符的源当成远端，报
# "The source and destination cannot both be remote"
run_rsync() {
  if [[ $USE_WSL -eq 1 ]]; then
    MSYS2_ARG_CONV_EXCL='*' MSYS_NO_PATHCONV=1 wsl -e rsync "$@"
  else
    rsync "$@"
  fi
}

echo "==> 构建 (hexo generate，增量)"
npx hexo generate

# 构建自检：渲染器缺失时 hexo 会"成功"生成 0 篇文章，这里必须拦住
if [[ ! -s public/index.html ]] || ! grep -q '<article class="post">' public/index.html; then
  echo "❌ 构建产物异常：public/index.html 里没有文章列表" >&2
  echo "   常见原因：改过 package.json 却没 npm install（缺 hexo-renderer-markdown-it）" >&2
  exit 1
fi

if [[ $DRY -eq 1 ]]; then
  echo "==> rsync 预览（未上线）"
  run_rsync -azni "${RSYNC_OPTS[@]}" "$SRC" "$REMOTE"
  echo "dry-run 结束"
  exit 0
fi

echo "==> rsync 上线"
run_rsync -az "${RSYNC_OPTS[@]}" "$SRC" "$REMOTE"

echo "==> git 归档"
git add -A
if git diff --cached --quiet; then
  echo "内容无变化，跳过提交"
else
  if [[ -z "$MSG" ]]; then
    # 兜底消息：只有文件名可依据（理想情况是代理/用户传入概括内容的消息）
    changed=$(git diff --cached --name-only)
    posts=$(echo "$changed" | grep '^source/_posts/.*\.md$' || true)
    join_names() { awk '{printf "%s%s", (NR>1 ? "、" : ""), $0}'; }
    if [[ -n "$posts" && "$(echo "$changed" | wc -l)" -eq "$(echo "$posts" | grep -c .)" ]]; then
      new_posts=$(git diff --cached --name-only --diff-filter=A -- source/_posts | grep '\.md$' || true)
      if [[ -n "$new_posts" ]]; then
        MSG="docs: 新增文章 $(echo "$new_posts" | xargs -n1 basename | sed 's/\.md$//' | join_names)"
      else
        n=$(echo "$posts" | grep -c .)
        names=$(echo "$posts" | head -3 | xargs -n1 basename | sed 's/\.md$//' | join_names)
        [[ $n -gt 3 ]] && names="$names 等 ${n} 篇"
        MSG="docs: 更新文章 $names"
      fi
    elif [[ "$changed" == themes/* ]]; then
      MSG="chore: 更新主题"
    else
      MSG="chore: 站点维护"
    fi
  fi
  git commit -m "$MSG"
  git push
  echo "已归档: $(git log -1 --format='%h %s')"
fi

echo "✅ 发布完成，耗时 ${SECONDS}s"
