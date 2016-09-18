--------------------------------------------------------------------------------
-- FFI / .so debugging with ADB
--------------------------------------------------------------------------------
-- Alfredo Canziani, Sep 16
--------------------------------------------------------------------------------

-- FFI stuff -------------------------------------------------------------------
-- Require ffi
ffi = require("ffi")
-- Load myLib
myLib = ffi.load(paths.cwd() .. '/libsegfault.so')
-- Function prototypes definition
ffi.cdef [[
   void A();
]]

-- Main program ----------------------------------------------------------------
local red = require('trepl.colorize').red
print(red 'Running a function from a shared object')
myLib.A()
print(red 'Never here')
