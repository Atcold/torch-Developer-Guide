--------------------------------------------------------------------------------
-- FFI and .so library
--------------------------------------------------------------------------------
-- Alfredo Canziani, Nov 14
--------------------------------------------------------------------------------

-- Instructions ----------------------------------------------------------------
-- You can run this code and see the results of the operation (1st option) or
-- you can increase the lenght of the tensor and turn off the printing

-- Choose a combination (comment the other)
--<<<
length = 5; display = true
--<<<>>>
--length = 1e7; display = false
-->>>

-- FFI stuff -------------------------------------------------------------------
-- Require ffi
ffi = require("ffi")
-- Load myLib
local myLib = ffi.load(paths.cwd() .. '/libasdf.so')
-- Function prototypes definition
ffi.cdef [[
   void dummy(int* ptr_form_lua, int size)
]]

-- Shortcuts -------------------------------------------------------------------
-- printf
pf = function(...) print(string.format(...)) end

-- Main program ----------------------------------------------------------------
a = torch.IntTensor(length):random()
b = a:clone()
if display then
   print('Random vector')
   print(a)
end

timer = torch.Timer()
myLib.dummy(torch.data(a), length)
pf('C function computation time %.2f ms', timer:time().real*1e3)
if display then print(a) end

timer = torch.Timer()
for i = 1, length do b[i] = i end
pf('Lua loop computation time %.2f ms', timer:time().real*1e3)
if display then print(b) end
