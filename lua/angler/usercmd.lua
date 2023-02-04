local c, ts = require("angler.utils").create_cmd, require("angler.typescript")

c("AnglerPopulateQF", ts.quick_fix)
c("AnglerFixAll", ts.fix_all)
c("AnglerRenameFile", ts.rename_file)
c("AnglerRenameSymbol", ts.rename_symbol)
