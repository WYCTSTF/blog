-- 博客仓库专属配置（nvim exrc，需在仓库根目录打开 nvim）
-- :Pub 发布博客 —— 终端分屏里跑 ./publish.sh，输出可滚动；
-- 成功：摘结果行发通知并自动关闭（不留页签）；失败：保留输出供排查
-- 用法: :Pub | :Pub --dry-run | :Pub docs: 写了xxx
vim.api.nvim_create_user_command('Pub', function(o)
  local cmd = './publish.sh'
  if o.args ~= '' then
    cmd = cmd .. ' ' .. vim.fn.shellescape(o.args)
  end
  vim.cmd('15split | terminal ' .. cmd)
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = 0,
    once = true,
    callback = function(ev)
      local ok = vim.v.event.status == 0
      vim.defer_fn(function()
        -- 取末尾非空行做结果摘要（publish.sh 结尾是"已归档/✅ 发布完成，耗时 Xs"）
        local n = vim.api.nvim_buf_line_count(ev.buf)
        local lines = vim.api.nvim_buf_get_lines(ev.buf, math.max(0, n - 8), n, false)
        local tail = {}
        for _, l in ipairs(lines) do
          if l:match('%S') then table.insert(tail, l) end
        end
        local start = math.max(1, #tail - 1)
        local summary = {}
        for i = start, #tail do
          table.insert(summary, tail[i])
        end
        local win = vim.fn.bufwinid(ev.buf)
        if ok then
          if win ~= -1 and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
          if vim.api.nvim_buf_is_valid(ev.buf) then
            vim.api.nvim_buf_delete(ev.buf, { force = true })
          end
          vim.notify('✅ ' .. table.concat(summary, '\n'), vim.log.levels.INFO, { title = 'Pub' })
        else
          vim.notify('❌ 发布失败，终端输出已保留', vim.log.levels.ERROR, { title = 'Pub' })
        end
      end, 150)
    end,
  })
end, { nargs = '?' })
