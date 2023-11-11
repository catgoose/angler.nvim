local c, ts = require("angler.utils").create_cmd, require("angler.typescript")

c("AnglerCompile", ts.compile_ts)
c("AnglerFixAll", ts.fix_all)
c("AnglerRenameFile", ts.rename_file)
c("AnglerRenameSymbol", ts.rename_symbol)
