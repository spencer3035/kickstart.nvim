local jdtls_path = require('mason-registry').get_package('jdtls'):get_install_path()
local jdtls_bin = jdtls_path .. '/jdtls'
local jdtls_config = jdtls_path .. '/../../share/jdtls'
local lombok_jar = '/home/spencer.littel_cn/.m2/repository/org/projectlombok/lombok/1.18.34/lombok-1.18.34.jar'

local home = vim.fn.expand '~'
local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'
local lombok_path = mason_path .. '/lombok.jar'

-- Define workspace path
local workspace_path = home .. '/.local/share/nvim/java_workspace/'

local config = {

  -- Configure `nvim-jdtls`
  cmd = {
    'java',
    '-javaagent:' .. lombok_path,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms2g',
    '-XX:+UseG1GC',
    '-XX:+UseStringDeduplication',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    --vim.fn.glob(mason_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    jdtls_config .. '/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    '-configuration',
    mason_path .. '/config_linux',
    '-data',
    workspace_path .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
  },
  --cmd = {
  --  jdtls_path,
  --  '-javaagent',
  --  '/home/spencer.littel_cn/.m2/repository/org/projectlombok/lombok/1.18.34/lombok-1.18.34.jar',
  --},

  --cmd = {
  --jdtls_bin,
  --'--jvm-arg=-javaagent /home/spencer.littel_cn/.m2/repository/org/projectlombok/lombok/1.18.34/lombok-1.18.34.jar',

  -- 💀
  --'java', -- or '/path/to/java17_or_newer/bin/java'
  ---- depends on if `java` is in your $PATH env variable and if it points to the right version.

  --'-Declipse.application=org.eclipse.jdt.ls.core.id1',
  --'-Dosgi.bundles.defaultStartLevel=4',
  --'-Declipse.product=org.eclipse.jdt.ls.core.product',
  --'-Dlog.protocol=true',
  --'-Dlog.level=ALL',
  --'-Xmx1g',
  --'--add-modules=ALL-SYSTEM',
  --'--add-opens',
  --'java.base/java.util=ALL-UNNAMED',
  --'--add-opens',
  --'java.base/java.lang=ALL-UNNAMED',

  ---- 💀
  --'-jar',
  --jdtls_config .. '/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
  ---- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
  ---- Must point to the                                                     Change this to
  ---- eclipse.jdt.ls installation                                           the actual version

  ---- 💀
  --'-configuration',
  --jdtls_config,
  --'/config_linux',
  -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
  -- Must point to the                      Change to one of `linux`, `win` or `mac`
  -- eclipse.jdt.ls installation            Depending on your system.

  -- See `data directory configuratikon` section in the README
  --'-data', '/path/to/unique/per/project/workspace/folder'
  --},
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}

require('jdtls').start_or_attach(config)
