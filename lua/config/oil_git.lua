local M = {}

function M.setup()
  local process = require("oil-git-status.system")
  local system = process.system

  --[[ Oil needs individual untracked entries even when the entire open
       directory is untracked. Keep this option local to the plugin. ]]
  process.system = function(cmd, opts, callback)
    if cmd[1] ~= "git" or not vim.tbl_contains(cmd, "status") then
      return system(cmd, opts, callback)
    end

    cmd = vim.list_extend(vim.deepcopy(cmd), { "--untracked-files=all" })
    return system(cmd, opts, function(result)
      if result.code == 0 then
        local lines, directories = {}, {}
        for _, line in ipairs(vim.split(result.stdout, "\n", { trimempty = true })) do
          local directory = line:sub(1, 3) == "?? " and line:sub(4):match('^"?([^/]+)/')
          --[[ The plugin aggregates repeated directory entries as modified.
               One untracked child is sufficient to mark its directory as untracked. ]]
          if not directory or not directories[directory] then
            lines[#lines + 1] = line
          end
          if directory then
            directories[directory] = true
          end
        end
        result.stdout = table.concat(lines, "\n")
      end
      callback(result)
    end)
  end
end

return M
