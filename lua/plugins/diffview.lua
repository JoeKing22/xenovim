-- Current-line blame for the OURS / THEIRS / BASE panes of the merge view.
-- Those panes show index stages (diffview://<gitdir>/:<stage>:/<path>), so
-- each stage is blamed against the commit it was taken from.
local blame_ns = vim.api.nvim_create_namespace("diffview_merge_blame")
local blame_by_buf = {}

local function their_head(gitdir)
    for _, name in ipairs({ "MERGE_HEAD", "REBASE_HEAD", "CHERRY_PICK_HEAD", "REVERT_HEAD" }) do
        if vim.uv.fs_stat(gitdir .. "/" .. name) then
            return name
        end
    end
end

local function stage_rev(gitdir, stage)
    if stage == "2" then
        return "HEAD"
    end
    local theirs = their_head(gitdir)
    if not theirs then
        return nil
    end
    if stage == "3" then
        return theirs
    end
    local out = vim.system({ "git", "--git-dir", gitdir, "merge-base", "HEAD", theirs }, { text = true }):wait()
    return out.code == 0 and vim.trim(out.stdout) or nil
end

local function relative_time(timestamp)
    local diff = os.time() - timestamp
    local units = { { 31536000, "year" }, { 2592000, "month" }, { 604800, "week" }, { 86400, "day" }, { 3600, "hour" } }
    for _, unit in ipairs(units) do
        local count = math.floor(diff / unit[1])
        if count >= 1 then
            return ("%d %s%s ago"):format(count, unit[2], count > 1 and "s" or "")
        end
    end
    return "just now"
end

local function parse_porcelain(output)
    local commits, lines = {}, {}
    local hash, line_nr
    for _, line in ipairs(vim.split(output, "\n", { plain = true })) do
        local h, final = line:match("^(%x+) %d+ (%d+)")
        if h and #h == 40 then
            hash, line_nr = h, tonumber(final)
            commits[hash] = commits[hash] or { hash = hash }
        elseif line:sub(1, 1) == "\t" then
            lines[line_nr] = commits[hash]
        elseif hash then
            local key, value = line:match("^(%S+) (.*)$")
            if key == "author" or key == "summary" then
                commits[hash][key] = value
            elseif key == "author-time" then
                commits[hash].time = tonumber(value)
            end
        end
    end
    return lines
end

local function show_blame(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, blame_ns, 0, -1)
    local blame = blame_by_buf[bufnr]
    if not blame or vim.api.nvim_get_current_buf() ~= bufnr then
        return
    end
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local info = blame[row]
    if not info then
        return
    end
    local text = ("    %s %s, %s • %s"):format(
        info.hash:sub(1, 9),
        info.author or "?",
        info.time and relative_time(info.time) or "?",
        info.summary or ""
    )
    vim.api.nvim_buf_set_extmark(bufnr, blame_ns, row - 1, 0, { virt_text = { { text, "Comment" } } })
end

local function attach_blame(bufnr)
    local gitdir, stage, path = vim.api.nvim_buf_get_name(bufnr):match("^diffview://(.-)/:(%d):/(.+)$")
    if not gitdir or vim.b[bufnr].diffview_blame_attached then
        return
    end
    vim.b[bufnr].diffview_blame_attached = true

    local rev = stage_rev(gitdir, stage)
    if not rev then
        return
    end
    vim.system({ "git", "--git-dir", gitdir, "blame", "--porcelain", rev, "--", path }, { text = true }, function(out)
        if out.code ~= 0 then
            return
        end
        local lines = parse_porcelain(out.stdout)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                blame_by_buf[bufnr] = lines
                show_blame(bufnr)
            end
        end)
    end)

    local group = vim.api.nvim_create_augroup("diffview_merge_blame_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            show_blame(bufnr)
        end,
    })
    vim.api.nvim_create_autocmd("BufLeave", {
        group = group,
        buffer = bufnr,
        callback = function()
            vim.api.nvim_buf_clear_namespace(bufnr, blame_ns, 0, -1)
        end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        buffer = bufnr,
        callback = function()
            blame_by_buf[bufnr] = nil
        end,
    })
end

-- Conflict counter in the LOCAL pane's winbar, e.g. "Conflict 2 of 5".
-- Marker positions are cached per buffer and rescanned only when it changes.
local conflict_cache = {}

local function conflict_ranges(bufnr)
    local tick = vim.api.nvim_buf_get_changedtick(bufnr)
    local cached = conflict_cache[bufnr]
    if cached and cached.tick == tick then
        return cached.ranges
    end
    local ranges, start = {}, nil
    for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        if line:sub(1, 7) == "<<<<<<<" then
            start = i
        elseif start and line:sub(1, 7) == ">>>>>>>" then
            table.insert(ranges, { start, i })
            start = nil
        end
    end
    conflict_cache[bufnr] = { tick = tick, ranges = ranges }
    return ranges
end

function _G.DiffviewConflictStatus()
    local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
    local ranges = conflict_ranges(vim.api.nvim_win_get_buf(winid))
    if #ranges == 0 then
        return "No conflicts left ✓"
    end
    local row = vim.api.nvim_win_get_cursor(winid)[1]
    for i, range in ipairs(ranges) do
        if row >= range[1] and row <= range[2] then
            return ("Conflict %d of %d"):format(i, #ranges)
        end
    end
    return ("%d conflict%s"):format(#ranges, #ranges > 1 and "s" or "")
end

local function add_conflict_counter(_, winid, ctx)
    if ctx.symbol ~= "b" or not ctx.layout_name:match("^diff[34]") then
        return
    end
    local winbar = vim.wo[winid].winbar
    if not winbar:find("DiffviewConflictStatus", 1, true) then
        vim.wo[winid].winbar = winbar .. "%=%{v:lua.DiffviewConflictStatus()} "
    end
end

return {
    "dlyongemallo/diffview-plus.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {
        view = {
            merge_tool = {
                layout = "diff3_mixed",
                disable_diagnostics = true,
            },
        },
        hooks = {
            diff_buf_read = attach_blame,
            diff_buf_win_enter = add_conflict_counter,
        },
    },
}
