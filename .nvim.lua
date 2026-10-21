-- 博客仓库专属配置（nvim exrc，需在仓库根目录打开 nvim）
-- :Pub 发布博客 —— 终端分屏里跑 ./publish.sh，输出是真实 buffer、可滚动，
-- 不走消息管道所以不受任何 UI 插件影响
-- 用法: :Pub | :Pub --dry-run | :Pub docs: 写了xxx
vim.api.nvim_create_user_command('Pub', function(o)
  local cmd = './publish.sh'
  if o.args ~= '' then
    cmd = cmd .. ' ' .. vim.fn.shellescape(o.args)
  end
  vim.cmd('15split | terminal ' .. cmd)
end, { nargs = '?' })
