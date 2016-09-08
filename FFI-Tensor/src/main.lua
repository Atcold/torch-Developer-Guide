--------------------------------------------------------------------------------
-- Tensors through FFI
--------------------------------------------------------------------------------
-- Alfredo Canziani, Sep 16
--------------------------------------------------------------------------------

-- FFI stuff -------------------------------------------------------------------
-- Require ffi
local ffi = require 'ffi'
-- Load myLib
local C = ffi.load('libsize.so')
-- Function prototypes definition
ffi.cdef[[
void printSize(THFloatTensor* src);
]]

-- Main program ----------------------------------------------------------------
-- Define a random sized Tensor
math.randomseed(os.time())
x = torch.FloatTensor(unpack(torch.Tensor(math.random(10)):random(10):totable()))
-- Send it to C
C.printSize(x:cdata())

-- Lua printing functions
print('Lua says:')
print(' + Dimension: ' .. x:dim())
io.write(' + Size: ' .. x:size(1))
for d = 2, x:dim() do io.write(' x ' .. x:size(d)) end
io.write('\n')
