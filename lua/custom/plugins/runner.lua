local function contains(tbl)
  local ft = vim.bo.filetype
  for _, str in ipairs(tbl) do
    if str == ft then
      return true
    end
  end
  return false
end

local function get_basename(str)
  local current = ''
  for token in string.gmatch(str, '([^/]+)') do
    current = token
  end

  local dir = current
  return dir
end

local function get_dir(str)
  local current = ''
  local previous = ''
  for token in string.gmatch(str, '([^/]+)') do
    previous = current
    current = token
  end

  local dir = previous
  return dir
end

local function file_exists(filename)
  local file = io.open(filename, 'r')
  if file then
    file:close()
    return true
  else
    return false
  end
end

local function run_code_new_window(run_cmd)
  -- Update current working window
  if run_cmd ~= '' then
    vim.cmd('vsplit | terminal ' .. run_cmd)
    vim.cmd 'norm G'
    -- We could make this a stack
    vim.g['working_window_id'] = vim.call 'win_getid'
    vim.cmd 'wincmd l | wincmd R'
  end
end

local function run_code_in_existing_window(run_cmd)
  local current_window = vim.call 'win_getid'
  -- Only close the current working window
  if vim.g['working_window_id'] ~= nil then
    local ret_val = vim.call('win_gotoid', vim.g['working_window_id'])
    -- Only close value if we have a valid id.
    if ret_val == 1 then
      vim.cmd 'bd'
      vim.call('win_gotoid', current_window)
    end
  end
  if run_cmd == '' then
    run_code_new_window(run_cmd)
  else
    run_code_new_window(run_cmd)
  end
end

local function get_test_command()
  -- Use test_command if it is set
  local test_cmd = ''
  if vim.g['test_command'] ~= nil then
    test_cmd = vim.g['test_command']
    -- Could put generic test stuff like cargo test in else
  else
    local ft = vim.bo.filetype
    if ft == 'rust' then
      test_cmd = 'cargo test'
      print('Setting test_cmd to ' .. test_cmd)
    end
    if file_exists 'Makefile' then
      test_cmd = 'make'
    end
  end

  if test_cmd ~= '' then
    return test_cmd
  else
    return nil
  end
end

function Test_code(new_window)
  local test_cmd = get_test_command()
  if test_cmd ~= nil then
    if new_window then
      run_code_new_window(test_cmd)
    else
      run_code_in_existing_window(test_cmd)
    end
  else
    print 'No test command specified'
  end
end

local function get_run_command()
  -- Use run_command if it is set
  local run_cmd = ''
  local filename = vim.api.nvim_buf_get_name(0)
  local dir = get_dir(filename)
  local base_file = get_basename(filename)

  if vim.g['run_command'] ~= nil then
    run_cmd = vim.g['run_command']
  else
    local ft = vim.bo.filetype
    if ft == 'python' then
      run_cmd = 'python3 ' .. filename
    end
    if ft == 'cs' then
      run_cmd = 'dotnet run'
    end
    if ft == 'lean' then
      run_cmd = 'lean ' .. filename
    end
    if ft == 'rust' then
      if dir == 'examples' then
        local length = string.len(base_file)
        local trimmed_filename = string.sub(base_file, 0, length - 3)
        print('Cut str = ' .. trimmed_filename)

        run_cmd = 'cargo run --quiet --example ' .. trimmed_filename
      else
        run_cmd = 'cargo run'
      end
    end
    if ft == 'lua' then
      run_cmd = 'lua ' .. filename
    end
    if ft == 'cpp' then
      run_cmd = 'g++ ' .. filename .. ' && ./a.out'
    end
    if ft == 'java' then
      run_cmd = 'javac SlimeHoneyPlacer.java && java $(ls | sed -n "s/.class//p")'
    end
    if ft == 'sh' then
      run_cmd = filename
    end
    if ft == 'c' then
      run_cmd = 'gcc ' .. filename .. ' && ./a.out'
    end
    if ft == 'asm' then
      run_cmd = 'nasm -felf64 ' .. filename .. ' -o a.o && ld a.o && rm a.o && ./a.out'
    end
    if file_exists 'Makefile' then
      run_cmd = 'make run'
    end
  end

  if run_cmd ~= '' then
    return run_cmd
  else
    return nil
  end
end

function Run_code(new_window)
  -- Use run_command if it is set
  local run_cmd = get_run_command()
  if run_cmd ~= nil then
    if new_window then
      run_code_new_window(run_cmd)
    else
      run_code_in_existing_window(run_cmd)
    end
  else
    print 'No run command was found'
  end
end

----------------------
-- Generic settings --
----------------------

if contains { 'cpp', 'rust', 'java', 'c', 'cs' } then
  -- Brackets complete on enter.
  vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O')

  -- Set 80 column border
  vim.opt.cc = '81'
end

----------------------------
-- Type Specific settings --
----------------------------

-- Text documents
if contains { 'text' } then
  vim.opt.textwidth = 80
end

-- git
if contains { 'gitcommit', 'gitrebase' } then
  -- Set 70 column border cause that's what git likes.
  vim.opt.cc = '71'
end

-- LaTeX
-- TODO
