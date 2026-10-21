#!/usr/bin/env bash
# 一条命令发布博客：增量构建 → rsync 上线 → git 归档（后台账本，不再是发布门槛）
# 用法: ./publish.sh [commit 消息]     完整发布
#       ./publish.sh --dry-run         只构建 + rsync 预览，不上线不提交
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

echo "==> 构建 (hexo generate，增量)"
npx hexo generate

if [[ $DRY -eq 1 ]]; then
  echo "==> rsync 预览（未上线）"
  rsync -azni "${RSYNC_OPTS[@]}" public/ "$REMOTE"
  echo "dry-run 结束"
  exit 0
fi

# 主题改动需先推送 fork 再更新指针（既有约定）；这里只提醒不阻塞
if dirty=$(git submodule status --recursive | grep -E '^(\+|m)'); then
  echo "⚠️  子模块与记录的指针不一致（改动还没推送到 fork？）:"
  echo "$dirty"
fi

echo "==> rsync 上线"
rsync -az "${RSYNC_OPTS[@]}" public/ "$REMOTE"

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
      MSG="chore: 更新主题子模块"
    else
      MSG="chore: 站点维护"
    fi
  fi
  git commit -m "$MSG"
  git push
  echo "已归档: $(git log -1 --format='%h %s')"
fi

echo "✅ 发布完成，耗时 ${SECONDS}s"
